import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../data/mock/mock_data.dart';
import '../../domain/models/chat.dart';
import '../../domain/models/chat_message.dart';
import '../../widgets/feedback_x.dart';
import '../../widgets/poe_avatar.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  bool _searching = false;
  String _query = '';

  List<Chat> get _filtered {
    if (_query.isEmpty) return MockData.chats;
    final q = _query.toLowerCase();
    return MockData.chats
        .where(
          (c) =>
              c.title.toLowerCase().contains(q) ||
              c.subtitle.toLowerCase().contains(q),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final chats = _filtered;
    return Scaffold(
      appBar: AppBar(
        title: _searching
            ? TextField(
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                style: Theme.of(context).textTheme.titleLarge,
                decoration: const InputDecoration(
                  hintText: 'Search chats…',
                  border: InputBorder.none,
                  isDense: true,
                ),
                onChanged: (v) => setState(() => _query = v),
              )
            : const Text('PoePoe'),
        actions: [
          IconButton(
            icon: Icon(_searching ? Icons.close_rounded : Icons.search_rounded),
            onPressed: () {
              setState(() {
                _searching = !_searching;
                if (!_searching) _query = '';
              });
            },
            tooltip: _searching ? 'Cancel' : 'Search',
          ),
          IconButton(
            icon: const Icon(Icons.edit_square),
            onPressed: () => _showNewChatSheet(context),
            tooltip: 'New chat',
          ),
        ],
      ),
      body: chats.isEmpty
          ? _EmptyState(query: _query)
          : ListView.separated(
              itemCount: chats.length,
              separatorBuilder: (_, __) => const Padding(
                padding: EdgeInsets.only(left: 88),
                child: Divider(height: 1, thickness: 0.5),
              ),
              itemBuilder: (context, index) {
                final chat = chats[index];
                return _ChatTile(chat: chat);
              },
            ),
    );
  }

  void _showNewChatSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        final contacts = MockData.contacts;
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
                child: Text(
                  'New chat',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              ...contacts.map(
                (c) => ListTile(
                  leading: PoeAvatar(
                    url: c.avatarUrl,
                    name: c.name,
                    size: 44,
                    isOnline: c.isOnline,
                  ),
                  title: Text(c.name),
                  subtitle: Text(c.status ?? ''),
                  onTap: () {
                    Navigator.pop(ctx);
                    // Find existing chat with this contact, else show "coming soon".
                    final existing = MockData.chats.firstWhere(
                      (ch) => ch.participants.any((p) => p.id == c.id),
                      orElse: () => MockData.chats.first,
                    );
                    context.goNamed(
                      'chatRoom',
                      pathParameters: {'id': existing.id},
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.query});
  final String query;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 12),
            Text(
              'No chats found for "$query"',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatTile extends StatelessWidget {
  const _ChatTile({required this.chat});
  final Chat chat;

  @override
  Widget build(BuildContext context) {
    final last = chat.lastMessage;
    final isMine = last?.isMine ?? false;
    final theme = Theme.of(context);

    return Dismissible(
      key: ValueKey(chat.id),
      background: Container(
        color: theme.colorScheme.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        FeedbackX.comingSoon(context, 'Delete chat');
        return false;
      },
      child: InkWell(
        onTap: () =>
            context.goNamed('chatRoom', pathParameters: {'id': chat.id}),
        onLongPress: () => _showChatOptions(context, chat),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              PoeAvatar(
                url: chat.avatarUrl,
                name: chat.title,
                size: 56,
                isOnline: chat.participants.any((p) => p.isOnline) &&
                    !chat.isGroup,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            chat.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        if (last != null) ...[
                          const SizedBox(width: 6),
                          Text(
                            _formatTime(last.sentAt),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if (isMine)
                          Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: Icon(
                              Icons.done_all_rounded,
                              size: 16,
                              color: last?.status == MessageStatus.read
                                  ? const Color(0xFF4FA8FF)
                                  : theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        Expanded(
                          child: Text(
                            chat.subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                        if (chat.unreadCount > 0)
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            constraints: const BoxConstraints(minWidth: 20),
                            child: Text(
                              '${chat.unreadCount}',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showChatOptions(BuildContext context, Chat chat) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          child: ListTile(
            leading: const Icon(Icons.delete_outline_rounded),
            title: const Text('Delete chat'),
            onTap: () {
              Navigator.pop(ctx);
              FeedbackX.comingSoon(context, 'Delete chat');
            },
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final that = DateTime(dt.year, dt.month, dt.day);
    if (today == that) return DateFormat('h:mm a').format(dt);
    if (today.difference(that).inDays == 1) return 'Yesterday';
    return DateFormat('d/M/yy').format(dt);
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../data/mock/mock_data.dart';
import '../../domain/models/chat_message.dart';
import '../../widgets/feedback_x.dart';
import '../../widgets/poe_avatar.dart';

/// Placeholder chat room. Reads from MockData.
/// Step 3 will swap mock data for Firestore real-time streams.
class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({super.key, required this.chatId});

  final String chatId;

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  late final List<ChatMessage> _messages;
  final TextEditingController _controller = TextEditingController();
  bool _showEmojiPicker = false;

  @override
  void initState() {
    super.initState();
    _messages = List<ChatMessage>.from(
      MockData.messagesByChat[widget.chatId] ?? const <ChatMessage>[],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(
        ChatMessage(
          id: 'local-${DateTime.now().millisecondsSinceEpoch}',
          chatId: widget.chatId,
          senderId: 'me',
          text: text,
          sentAt: DateTime.now(),
          status: MessageStatus.sent,
        ),
      );
    });
    _controller.clear();

    // Simulate "delivered → read" tick after a short delay.
    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      setState(() {
        final last = _messages.lastWhere((m) => m.senderId == 'me');
        final idx = _messages.indexOf(last);
        _messages[idx] = ChatMessage(
          id: last.id,
          chatId: last.chatId,
          senderId: last.senderId,
          text: last.text,
          sentAt: last.sentAt,
          status: MessageStatus.read,
        );
      });
    });

    // Simulate an auto-reply for the welcome chat (c5) so the user sees
    // something happen immediately.
    if (widget.chatId == 'c5') {
      Future.delayed(const Duration(seconds: 1), () {
        if (!mounted) return;
        setState(() {
          _messages.add(
            ChatMessage(
              id: 'auto-${DateTime.now().millisecondsSinceEpoch}',
              chatId: widget.chatId,
              senderId: 'u5',
              text: 'Thanks for your message! Real-time replies arrive in step 3.',
              sentAt: DateTime.now(),
            ),
          );
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final chat = MockData.chats.firstWhere(
      (c) => c.id == widget.chatId,
      orElse: () => MockData.chats.first,
    );
    final peer =
        chat.participants.isNotEmpty ? chat.participants.first : null;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.goNamed('chats'),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            PoeAvatar(
              url: chat.avatarUrl,
              name: chat.title,
              size: 40,
              isOnline: peer?.isOnline ?? false,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chat.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    peer?.isOnline == true
                        ? 'online'
                        : 'last seen recently',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: peer?.isOnline == true
                          ? const Color(0xFF34C759)
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam_rounded),
            onPressed: () => FeedbackX.toast(
              context,
              'Video calling ${chat.title}…',
              icon: Icons.videocam_rounded,
            ),
            tooltip: 'Video call',
          ),
          IconButton(
            icon: const Icon(Icons.call_rounded),
            onPressed: () => FeedbackX.toast(
              context,
              'Calling ${chat.title}…',
              icon: Icons.call_rounded,
            ),
            tooltip: 'Voice call',
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded),
            onSelected: (v) {
              switch (v) {
                case 'search':
                  FeedbackX.comingSoon(context, 'Search in chat');
                  break;
                case 'mute':
                  FeedbackX.toast(
                    context,
                    'Notifications ${chat.title} muted',
                    icon: Icons.notifications_off_rounded,
                  );
                  break;
                case 'wallpaper':
                  FeedbackX.comingSoon(context, 'Chat wallpaper');
                  break;
                case 'clear':
                  setState(_messages.clear);
                  FeedbackX.toast(
                    context,
                    'Chat cleared',
                    icon: Icons.cleaning_services_rounded,
                  );
                  break;
                case 'block':
                  FeedbackX.toast(
                    context,
                    '${chat.title} blocked',
                    icon: Icons.block_rounded,
                  );
                  break;
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'search', child: Text('Search')),
              PopupMenuItem(value: 'mute', child: Text('Mute notifications')),
              PopupMenuItem(value: 'wallpaper', child: Text('Wallpaper')),
              PopupMenuItem(value: 'clear', child: Text('Clear chat')),
              PopupMenuItem(value: 'block', child: Text('Block contact')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? _EmptyConversation(name: chat.title)
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                    itemCount: _messages.length,
                    itemBuilder: (context, i) {
                      final m = _messages[i];
                      final showTail =
                          i == 0 || _messages[i - 1].senderId != m.senderId;
                      return _MessageBubble(message: m, showTail: showTail);
                    },
                  ),
          ),
          if (_showEmojiPicker)
            _EmojiBar(
              onPick: (e) {
                _controller.text = _controller.text + e;
              },
            ),
          _Composer(
            controller: _controller,
            onToggleEmoji: () {
              setState(() => _showEmojiPicker = !_showEmojiPicker);
              FeedbackX.toast(
                context,
                _showEmojiPicker ? 'Emoji picker' : 'Emoji picker closed',
                icon: Icons.sentiment_satisfied_rounded,
              );
            },
            onAttach: () => _showAttachSheet(context),
            onSend: _send,
          ),
        ],
      ),
    );
  }

  void _showAttachSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_outlined, color: Color(0xFF6C4EE3)),
                title: const Text('Photo'),
                onTap: () {
                  Navigator.pop(ctx);
                  FeedbackX.comingSoon(context, 'Photo picker');
                },
              ),
              ListTile(
                leading: const Icon(Icons.videocam_outlined, color: Color(0xFFFF7A59)),
                title: const Text('Video'),
                onTap: () {
                  Navigator.pop(ctx);
                  FeedbackX.comingSoon(context, 'Video picker');
                },
              ),
              ListTile(
                leading: const Icon(Icons.mic_none_rounded, color: Color(0xFF34C759)),
                title: const Text('Audio'),
                onTap: () {
                  Navigator.pop(ctx);
                  FeedbackX.comingSoon(context, 'Audio recorder');
                },
              ),
              ListTile(
                leading: const Icon(Icons.insert_drive_file_outlined, color: Color(0xFF4FA8FF)),
                title: const Text('Document'),
                onTap: () {
                  Navigator.pop(ctx);
                  FeedbackX.comingSoon(context, 'Document picker');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyConversation extends StatelessWidget {
  const _EmptyConversation({required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.waving_hand_rounded,
              size: 56,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 12),
            Text(
              'No messages yet',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Say hi to $name 👋',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message, required this.showTail});
  final ChatMessage message;
  final bool showTail;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMine = message.isMine;
    final isDark = theme.brightness == Brightness.dark;

    final bg = isMine
        ? (isDark
            ? const Color(0xFF8B6BFF)
            : const Color(0xFF6C4EE3))
        : (isDark ? const Color(0xFF2A2A2E) : const Color(0xFFF1F1F4));
    final fg = isMine ? Colors.white : theme.colorScheme.onSurface;

    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          top: showTail ? 8 : 2,
          bottom: 2,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.75,
        ),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMine ? 16 : (showTail ? 4 : 16)),
            bottomRight: Radius.circular(isMine ? (showTail ? 4 : 16) : 16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              message.text,
              style: theme.textTheme.bodyMedium?.copyWith(color: fg),
            ),
            const SizedBox(height: 3),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  DateFormat('h:mm a').format(message.sentAt),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: fg.withValues(alpha: 0.7),
                    fontSize: 10,
                  ),
                ),
                if (isMine) ...[
                  const SizedBox(width: 4),
                  Icon(
                    message.status == MessageStatus.read
                        ? Icons.done_all_rounded
                        : message.status == MessageStatus.sending
                            ? Icons.access_time_rounded
                            : Icons.check_rounded,
                    size: 14,
                    color: message.status == MessageStatus.read
                        ? const Color(0xFF4FA8FF)
                        : fg.withValues(alpha: 0.7),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Composer extends StatelessWidget {
  const _Composer({
    required this.controller,
    required this.onToggleEmoji,
    required this.onAttach,
    required this.onSend,
  });

  final TextEditingController controller;
  final VoidCallback onToggleEmoji;
  final VoidCallback onAttach;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconButton(
              onPressed: onAttach,
              icon: Icon(
                Icons.add_circle_outline_rounded,
                color: theme.colorScheme.primary,
              ),
            ),
            Expanded(
              child: TextField(
                controller: controller,
                minLines: 1,
                maxLines: 5,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: 'Message',
                  isDense: true,
                  filled: true,
                  fillColor: theme.colorScheme.surfaceContainerHigh,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  suffixIcon: IconButton(
                    onPressed: onToggleEmoji,
                    icon: Icon(
                      Icons.sentiment_satisfied_outlined,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                onSubmitted: (_) => onSend(),
              ),
            ),
            const SizedBox(width: 6),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller,
              builder: (context, value, _) {
                final hasText = value.text.trim().isNotEmpty;
                return Material(
                  color: hasText
                      ? theme.colorScheme.primary
                      : theme.colorScheme.surfaceContainerHigh,
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: hasText ? onSend : onAttach,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Icon(
                        hasText
                            ? Icons.send_rounded
                            : Icons.mic_rounded,
                        color: hasText
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.onSurfaceVariant,
                        size: 22,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _EmojiBar extends StatelessWidget {
  const _EmojiBar({required this.onPick});
  final ValueChanged<String> onPick;

  static const _emojis = [
    '😀', '😁', '😂', '🤣', '😊', '😍', '😘', '😎',
    '🤔', '😴', '😇', '🥳', '😢', '😭', '😡', '👍',
    '👎', '👏', '🙏', '💪', '❤️', '🔥', '🎉', '✨',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 220,
      padding: const EdgeInsets.all(12),
      color: theme.colorScheme.surfaceContainerLow,
      child: GridView.count(
        crossAxisCount: 8,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        children: _emojis
            .map(
              (e) => InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () => onPick(e),
                child: Center(
                  child: Text(e, style: const TextStyle(fontSize: 24)),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

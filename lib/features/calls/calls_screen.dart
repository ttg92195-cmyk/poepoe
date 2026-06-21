import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/mock/mock_data.dart';
import '../../domain/models/call_entry.dart';
import '../../widgets/feedback_x.dart';
import '../../widgets/poe_avatar.dart';

class CallsScreen extends StatelessWidget {
  const CallsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final calls = MockData.calls;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calls'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () => FeedbackX.comingSoon(context, 'Search calls'),
            tooltip: 'Search',
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: calls.length + 1,
        separatorBuilder: (_, __) => const Padding(
          padding: EdgeInsets.only(left: 80),
          child: Divider(height: 1, thickness: 0.5),
        ),
        itemBuilder: (context, i) {
          if (i == 0) {
            return _StartCallTile(
              onTap: () => _showNewCallSheet(context),
            );
          }
          return _CallTile(entry: calls[i - 1]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNewCallSheet(context),
        child: const Icon(Icons.add_call_rounded),
      ),
    );
  }

  void _showNewCallSheet(BuildContext context) {
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
                  'Start a new call',
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
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.call_rounded,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        onPressed: () {
                          Navigator.pop(ctx);
                          FeedbackX.toast(
                            context,
                            'Calling ${c.name} (voice)…',
                            icon: Icons.call_rounded,
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.videocam_rounded,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        onPressed: () {
                          Navigator.pop(ctx);
                          FeedbackX.toast(
                            context,
                            'Calling ${c.name} (video)…',
                            icon: Icons.videocam_rounded,
                          );
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    FeedbackX.toast(
                      context,
                      'Calling ${c.name}…',
                      icon: Icons.call_rounded,
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

class _StartCallTile extends StatelessWidget {
  const _StartCallTile({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add_call_rounded,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                'Start new call',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CallTile extends StatelessWidget {
  const _CallTile({required this.entry});
  final CallEntry entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final missed = entry.isMissed;
    final nameColor =
        missed ? theme.colorScheme.error : theme.colorScheme.onSurface;
    final subColor = missed
        ? theme.colorScheme.error
        : theme.colorScheme.onSurfaceVariant;

    final dirIcon = switch (entry.direction) {
      CallDirection.incoming => Icons.call_received_rounded,
      CallDirection.outgoing => Icons.call_made_rounded,
      CallDirection.missed => Icons.call_missed_rounded,
    };

    final subText = switch (entry.direction) {
      CallDirection.incoming =>
        'Incoming · ${entry.duration != null ? _fmtDur(entry.duration!) : 'missed'}',
      CallDirection.outgoing =>
        'Outgoing · ${entry.duration != null ? _fmtDur(entry.duration!) : '-'}',
      CallDirection.missed => 'Missed',
    };

    return InkWell(
      onTap: () => FeedbackX.toast(
        context,
        'Calling ${entry.name}…',
        icon: Icons.call_rounded,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            PoeAvatar(url: entry.avatarUrl, name: entry.name, size: 52),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: nameColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(dirIcon, size: 14, color: subColor),
                      const SizedBox(width: 4),
                      Text(
                        '$subText · ${_fmtTime(entry.at)}',
                        style:
                            theme.textTheme.bodySmall?.copyWith(color: subColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                entry.type == CallType.video
                    ? Icons.videocam_rounded
                    : Icons.call_rounded,
                color: theme.colorScheme.primary,
              ),
              onPressed: () => FeedbackX.toast(
                context,
                entry.type == CallType.video
                    ? 'Video calling ${entry.name}…'
                    : 'Calling ${entry.name}…',
                icon: entry.type == CallType.video
                    ? Icons.videocam_rounded
                    : Icons.call_rounded,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _fmtTime(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final that = DateTime(dt.year, dt.month, dt.day);
    if (today == that) return DateFormat('h:mm a').format(dt);
    if (today.difference(that).inDays == 1) return 'Yesterday';
    return DateFormat('d/M/yy').format(dt);
  }

  String _fmtDur(Duration d) {
    final m = d.inMinutes;
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '${m}m ${s}s';
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/mock/mock_data.dart';
import '../../domain/models/status_entry.dart';
import '../../widgets/feedback_x.dart';
import '../../widgets/poe_avatar.dart';

class StatusScreen extends StatelessWidget {
  const StatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Status'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () => FeedbackX.comingSoon(context, 'Search statuses'),
            tooltip: 'Search',
          ),
        ],
      ),
      body: ListView(
        children: [
          // My status
          InkWell(
            onTap: () => FeedbackX.toast(
              context,
              'Add a new status',
              icon: Icons.add_a_photo_rounded,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Stack(
                    children: [
                      PoeAvatar(
                        url: MockData.currentUser.avatarUrl,
                        name: MockData.currentUser.name,
                        size: 52,
                        showOnline: false,
                      ),
                      Positioned(
                        right: -2,
                        bottom: -2,
                        child: Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: theme.scaffoldBackgroundColor,
                              width: 2.5,
                            ),
                          ),
                          child: const Icon(
                            Icons.add_rounded,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'My status',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Tap to add status update',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (MockData.recentStatuses.isNotEmpty) ...[
            _SectionHeader(text: 'Recent updates'),
            ...MockData.recentStatuses.map((s) => _StatusTile(entry: s)),
          ],
          if (MockData.viewedStatuses.isNotEmpty) ...[
            _SectionHeader(text: 'Viewed updates'),
            ...MockData.viewedStatuses.map((s) => _StatusTile(entry: s)),
          ],
          const SizedBox(height: 16),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton.small(
            heroTag: 'status_edit',
            onPressed: () => FeedbackX.comingSoon(context, 'Text status'),
            child: const Icon(Icons.edit_rounded),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'status_camera',
            onPressed: () => FeedbackX.comingSoon(context, 'Camera status'),
            child: const Icon(Icons.camera_alt_rounded),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
      color: theme.colorScheme.surfaceContainerLow.withValues(alpha: 0.4),
      child: Text(
        text,
        style: theme.textTheme.labelLarge?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

class _StatusTile extends StatelessWidget {
  const _StatusTile({required this.entry});
  final StatusEntry entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ringColor =
        entry.viewed ? theme.colorScheme.outlineVariant : theme.colorScheme.primary;

    return InkWell(
      onTap: () => FeedbackX.toast(
        context,
        'Viewing ${entry.name}\'s status',
        icon: Icons.visibility_rounded,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(2.5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    ringColor.withValues(alpha: 0.4),
                    ringColor,
                  ],
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.scaffoldBackgroundColor,
                ),
                child: PoeAvatar(
                  url: entry.avatarUrl,
                  name: entry.name,
                  size: 48,
                  showOnline: false,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    DateFormat('h:mm a').format(entry.at),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

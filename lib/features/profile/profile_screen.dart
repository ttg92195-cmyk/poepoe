import 'package:flutter/material.dart';

import '../../data/mock/mock_data.dart';
import '../../widgets/poe_avatar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = MockData.currentUser;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 24),
        children: [
          Center(
            child: Column(
              children: [
                PoeAvatar(
                  url: user.avatarUrl,
                  name: user.name,
                  size: 112,
                  isOnline: user.isOnline,
                ),
                const SizedBox(height: 16),
                Text(
                  user.name,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.status ?? 'Hey there! I am using PoePoe.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.edit_rounded, size: 18),
                      label: const Text('Edit profile'),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.qr_code_2_rounded, size: 18),
                      label: const Text('QR code'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _Section(
            children: [
              _ListTile(
                icon: Icons.person_outline_rounded,
                title: 'Account',
                subtitle: 'Privacy, security, change number',
                onTap: () {},
              ),
              _ListTile(
                icon: Icons.notifications_none_rounded,
                title: 'Notifications',
                subtitle: 'Message, group & call tones',
                onTap: () {},
              ),
              _ListTile(
                icon: Icons.lock_outline_rounded,
                title: 'Privacy',
                subtitle: 'Block contacts, disappearing messages',
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 16),
          _Section(
            children: [
              _ListTile(
                icon: Icons.help_outline_rounded,
                title: 'Help',
                subtitle: 'Help center, contact us, terms',
                onTap: () {},
              ),
              _ListTile(
                icon: Icons.info_outline_rounded,
                title: 'About',
                subtitle: 'PoePoe v1.0.0 (Step 1 — Skeleton)',
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 16),
          _Section(
            children: [
              _ListTile(
                icon: Icons.logout_rounded,
                title: 'Log out',
                subtitle: null,
                color: theme.colorScheme.error,
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        children: [
          for (int i = 0; i < children.length; i++) ...[
            children[i],
            if (i != children.length - 1)
              const Padding(
                padding: EdgeInsets.only(left: 56),
                child: Divider(height: 1, thickness: 0.4),
              ),
          ],
        ],
      ),
    );
  }
}

class _ListTile extends StatelessWidget {
  const _ListTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.color,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleColor = color ?? theme.colorScheme.onSurface;
    final iconColor = color ?? theme.colorScheme.primary;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: (color ?? theme.colorScheme.primary)
                    .withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 20, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: titleColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

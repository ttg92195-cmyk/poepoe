import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/services/auth_service.dart';
import '../../domain/models/user_profile.dart';
import '../../providers/auth_providers.dart';
import '../../widgets/feedback_x.dart';
import '../../widgets/poe_avatar.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  late UserProfile _user;
  late final TextEditingController _nameCtl;
  late final TextEditingController _statusCtl;

  @override
  void initState() {
    super.initState();
    final fb = FirebaseAuth.instance.currentUser;
    _user = UserProfile(
      id: fb?.uid ?? 'me',
      name: fb?.displayName ?? fb?.email?.split('@').first ?? 'You',
      avatarUrl: fb?.photoURL,
      status: 'Hey there! I am using PoePoe.',
      isOnline: true,
    );
    _nameCtl = TextEditingController(text: _user.name);
    _statusCtl = TextEditingController(text: _user.status ?? '');
  }

  @override
  void dispose() {
    _nameCtl.dispose();
    _statusCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  url: _user.avatarUrl,
                  name: _user.name,
                  size: 112,
                  isOnline: _user.isOnline,
                ),
                const SizedBox(height: 16),
                Text(
                  _user.name,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _user.status ?? 'Hey there! I am using PoePoe.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton.icon(
                      onPressed: _openEditDialog,
                      icon: const Icon(Icons.edit_rounded, size: 18),
                      label: const Text('Edit profile'),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton.icon(
                      onPressed: () =>
                          FeedbackX.comingSoon(context, 'QR code'),
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
            title: 'Account',
            children: [
              _ListTile(
                icon: Icons.lock_outline_rounded,
                title: 'Privacy',
                subtitle: 'Block contacts, disappearing messages',
                onTap: () => FeedbackX.comingSoon(context, 'Privacy'),
              ),
              _ListTile(
                icon: Icons.notifications_none_rounded,
                title: 'Notifications',
                subtitle: 'Message, group & call tones',
                onTap: () => FeedbackX.comingSoon(context, 'Notifications'),
              ),
              _ListTile(
                icon: Icons.storage_rounded,
                title: 'Storage & data',
                subtitle: 'Network usage, auto-download',
                onTap: () => FeedbackX.comingSoon(context, 'Storage'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _Section(
            title: 'App',
            children: [
              _ListTile(
                icon: Icons.dark_mode_outlined,
                title: 'Dark mode',
                subtitle: 'Follow system',
                trailing: _ThemeDropdown(),
                onTap: () => FeedbackX.toast(
                  context,
                  'Use the dropdown to switch theme',
                  icon: Icons.palette_outlined,
                ),
              ),
              _ListTile(
                icon: Icons.language_rounded,
                title: 'App language',
                subtitle: 'English',
                onTap: () => FeedbackX.comingSoon(context, 'App language'),
              ),
              _ListTile(
                icon: Icons.help_outline_rounded,
                title: 'Help',
                subtitle: 'Help center, contact us, terms',
                onTap: () => FeedbackX.comingSoon(context, 'Help'),
              ),
              _ListTile(
                icon: Icons.info_outline_rounded,
                title: 'About',
                subtitle: 'PoePoe v1.0.0 (Step 2 — Tabs & feedback)',
                onTap: () => _showAboutDialog(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _Section(
            title: 'Session',
            children: [
              _ListTile(
                icon: Icons.logout_rounded,
                title: 'Log out',
                subtitle: FirebaseAuth.instance.currentUser?.email,
                color: theme.colorScheme.error,
                onTap: _logout,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Made with ❤️ using Flutter\nStep 3: Firebase Auth + Login UI',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text('You will need to sign in again to use PoePoe.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Log out'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref.read(authServiceProvider).signOut();
    if (!mounted) return;
    FeedbackX.toast(context, 'Signed out',
        icon: Icons.logout_rounded);
  }

  void _openEditDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameCtl,
              decoration: const InputDecoration(
                labelText: 'Display name',
                prefixIcon: Icon(Icons.person_outline_rounded),
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _statusCtl,
              decoration: const InputDecoration(
                labelText: 'Status',
                prefixIcon: Icon(Icons.sentiment_satisfied_outlined),
              ),
              textCapitalization: TextCapitalization.sentences,
              maxLength: 80,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final name = _nameCtl.text.trim();
              final status = _statusCtl.text.trim();
              if (name.isEmpty) {
                FeedbackX.toast(ctx, 'Name cannot be empty',
                    icon: Icons.error_outline_rounded);
                return;
              }
              setState(() {
                _user = UserProfile(
                  id: _user.id,
                  name: name,
                  avatarUrl: _user.avatarUrl,
                  status: status.isEmpty ? null : status,
                  isOnline: _user.isOnline,
                  lastSeen: _user.lastSeen,
                );
              });
              // Update Firebase display name in the background.
              final fb = FirebaseAuth.instance.currentUser;
              if (fb != null) {
                await fb.updateDisplayName(name);
              }
              if (!mounted) return;
              Navigator.pop(ctx);
              FeedbackX.toast(context, 'Profile updated',
                  icon: Icons.check_circle_rounded);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'PoePoe',
      applicationVersion: '1.0.0 (Step 2)',
      applicationLegalese: '© 2026 PoePoe',
      children: [
        const SizedBox(height: 12),
        const Text(
          'A modern Flutter messaging app built step-by-step. This is step 2: tabs and tap feedback.',
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
          child: Text(
            title,
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.4,
            ),
          ),
        ),
        Container(
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
        ),
      ],
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
    this.trailing,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final Color? color;
  final Widget? trailing;

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
            if (trailing != null)
              trailing!
            else
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

/// Tiny inline dropdown used to switch theme mode (local, in-memory only).
class _ThemeDropdown extends StatelessWidget {
  _ThemeDropdown();

  final ValueNotifier<ThemeMode> _mode =
      ValueNotifier<ThemeMode>(ThemeMode.system);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _mode,
      builder: (context, mode, _) {
        return DropdownButton<ThemeMode>(
          value: mode,
          underline: const SizedBox(),
          isDense: true,
          items: const [
            DropdownMenuItem(value: ThemeMode.system, child: Text('System')),
            DropdownMenuItem(value: ThemeMode.light, child: Text('Light')),
            DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
          ],
          onChanged: (v) {
            if (v == null) return;
            _mode.value = v;
            FeedbackX.toast(
              context,
              'Theme: ${v.name}',
              icon: Icons.palette_outlined,
            );
          },
        );
      },
    );
  }
}

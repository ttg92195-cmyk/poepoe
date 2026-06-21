import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/login_screen.dart';
import '../../features/auth/register_screen.dart';
import '../../features/chat_room/chat_room_screen.dart';
import '../../features/chats/chats_screen.dart';
import '../../features/calls/calls_screen.dart';
import '../../features/main/main_shell.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/status/status_screen.dart';
import '../../providers/auth_providers.dart';

/// App-wide navigation routes.
///
/// Step 3: routes are now gated on Firebase auth state. When no user
/// is signed in, the app forces the user to /login. When a user is
/// signed in, /login and /register redirect to /chats.
class AppRouter {
  AppRouter._();

  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');

  static final List<String> tabPaths = const [
    '/chats',
    '/status',
    '/calls',
    '/profile',
  ];

  static GoRouter build(WidgetRef ref) {
    return GoRouter(
      navigatorKey: rootNavigatorKey,
      initialLocation: '/chats',
      refreshListenable: _AuthListenable(ref),
      redirect: (context, state) {
        final signedIn = ref.read(isSignedInProvider);
        final goingToAuth =
            state.matchedLocation == '/login' ||
                state.matchedLocation == '/register';

        if (!signedIn && !goingToAuth) return '/login';
        if (signedIn && goingToAuth) return '/chats';
        return null;
      },
      routes: [
        GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          name: 'register',
          builder: (context, state) => const RegisterScreen(),
        ),
        ShellRoute(
          builder: (context, state, child) => MainShell(child: child),
          routes: [
            GoRoute(
              path: '/chats',
              name: 'chats',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: ChatsScreen(),
              ),
            ),
            GoRoute(
              path: '/status',
              name: 'status',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: StatusScreen(),
              ),
            ),
            GoRoute(
              path: '/calls',
              name: 'calls',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: CallsScreen(),
              ),
            ),
            GoRoute(
              path: '/profile',
              name: 'profile',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: ProfileScreen(),
              ),
            ),
          ],
        ),
        GoRoute(
          path: '/chat/:id',
          name: 'chatRoom',
          builder: (context, state) => ChatRoomScreen(
            chatId: state.pathParameters['id']!,
          ),
        ),
      ],
    );
  }
}

/// Bridges a Riverpod provider to GoRouter's ChangeNotifier API so
/// the router rebuilds whenever the auth state changes.
class _AuthListenable extends ChangeNotifier {
  _AuthListenable(WidgetRef ref) {
    ref.listen<AsyncValue<User?>>(authStateProvider, (_, __) {
      notifyListeners();
    });
  }
}

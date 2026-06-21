import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/chat_room/chat_room_screen.dart';
import '../../features/main/main_shell.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/chats/chats_screen.dart';

/// App-wide navigation routes. Updated in step 2 to add login/register.
class AppRouter {
  AppRouter._();

  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');

  static GoRouter build() {
    return GoRouter(
      navigatorKey: rootNavigatorKey,
      initialLocation: '/chats',
      routes: [
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

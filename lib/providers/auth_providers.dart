import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/services/auth_service.dart';

/// Singleton [AuthService] provider.
final authServiceProvider = Provider<AuthService>((ref) => AuthService.instance);

/// Stream of the current Firebase user. Emits null when signed out.
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});

/// Convenience bool: true when a user is currently signed in.
final isSignedInProvider = Provider<bool>((ref) {
  final user = ref.watch(authStateProvider).maybeWhen(
        data: (u) => u,
        orElse: () => null,
      );
  return user != null;
});

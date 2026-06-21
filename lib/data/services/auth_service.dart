import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Result of an auth attempt — either success (no message) or failure
/// with a human-readable message that can be shown in the UI.
sealed class AuthResult {
  const AuthResult();
}

class AuthSuccess extends AuthResult {
  final User user;
  const AuthSuccess(this.user);
}

class AuthFailure extends AuthResult {
  final String message;
  const AuthFailure(this.message);
}

/// Wraps [FirebaseAuth] so the rest of the app doesn't depend on the
/// SDK directly. Easy to mock in tests, easy to swap later.
class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Stream of the current user (null when signed out).
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Current user snapshot, or null.
  User? get currentUser => _auth.currentUser;

  /// Sign in with email + password.
  Future<AuthResult> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return AuthSuccess(cred.user!);
    } on FirebaseAuthException catch (e) {
      return AuthFailure(_humanError(e.code, e.message ?? 'Sign-in failed'));
    } catch (e) {
      debugPrint('signIn error: $e');
      return const AuthFailure('Something went wrong. Try again.');
    }
  }

  /// Create a new account with email + password.
  Future<AuthResult> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      if (cred.user != null && name.trim().isNotEmpty) {
        await cred.user!.updateDisplayName(name.trim());
      }
      return AuthSuccess(cred.user!);
    } on FirebaseAuthException catch (e) {
      return AuthFailure(_humanError(e.code, e.message ?? 'Registration failed'));
    } catch (e) {
      debugPrint('register error: $e');
      return const AuthFailure('Something went wrong. Try again.');
    }
  }

  /// Reset password for an email.
  Future<AuthResult> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      return AuthSuccess(_auth.currentUser!);
    } on FirebaseAuthException catch (e) {
      return AuthFailure(_humanError(e.code, e.message ?? 'Reset failed'));
    }
  }

  /// Sign out.
  Future<void> signOut() => _auth.signOut();

  /// Translate Firebase error codes into friendly Myanmar/English messages.
  String _humanError(String code, String fallback) {
    return switch (code) {
      'invalid-email' => 'Email format is invalid.',
      'user-disabled' => 'This account has been disabled.',
      'user-not-found' => 'No account found for this email.',
      'wrong-password' => 'Incorrect password.',
      'invalid-credential' => 'Email or password is incorrect.',
      'email-already-in-use' => 'This email is already registered.',
      'weak-password' => 'Password is too weak (at least 6 characters).',
      'operation-not-allowed' => 'Email/password sign-in is not enabled.',
      'network-request-failed' => 'Network error. Check your connection.',
      'too-many-requests' => 'Too many attempts. Please wait and try again.',
      _ => fallback,
    };
  }
}

/// App-wide constants for PoePoe Chat.
class AppConstants {
  AppConstants._();

  /// App display name.
  static const String appName = 'PoePoe';

  /// App tagline shown on splash/login.
  static const String tagline = 'Chat freely. Chat fast.';

  /// Default placeholder avatar URL.
  static const String placeholderAvatar =
      'https://ui-avatars.com/api/?background=random&name=P';

  /// Mock current user id (until Firebase auth is wired up in step 2).
  static const String currentUserId = 'me';
}

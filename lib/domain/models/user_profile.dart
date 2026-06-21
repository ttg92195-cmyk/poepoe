/// A single user in PoePoe Chat.
class UserProfile {
  final String id;
  final String name;
  final String? avatarUrl;
  final String? status;
  final bool isOnline;
  final DateTime? lastSeen;

  const UserProfile({
    required this.id,
    required this.name,
    this.avatarUrl,
    this.status,
    this.isOnline = false,
    this.lastSeen,
  });

  factory UserProfile.mock({
    required String id,
    required String name,
    bool isOnline = false,
    String? status,
  }) {
    return UserProfile(
      id: id,
      name: name,
      avatarUrl:
          'https://ui-avatars.com/api/?background=random&size=128&name=${Uri.encodeComponent(name)}',
      isOnline: isOnline,
      status: status,
      lastSeen: isOnline ? null : DateTime.now().subtract(const Duration(hours: 2)),
    );
  }
}

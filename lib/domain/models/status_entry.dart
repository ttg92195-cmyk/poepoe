/// A WhatsApp-style status / story update.
class StatusEntry {
  final String id;
  final String name;
  final String? avatarUrl;
  final String caption;
  final DateTime at;
  final bool viewed;

  const StatusEntry({
    required this.id,
    required this.name,
    this.avatarUrl,
    required this.caption,
    required this.at,
    this.viewed = false,
  });
}

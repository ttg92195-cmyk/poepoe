/// A single call log entry (incoming / outgoing / missed).
class CallEntry {
  final String id;
  final String name;
  final String? avatarUrl;
  final CallType type;
  final CallDirection direction;
  final DateTime at;
  final Duration? duration;

  const CallEntry({
    required this.id,
    required this.name,
    this.avatarUrl,
    required this.type,
    required this.direction,
    required this.at,
    this.duration,
  });

  bool get isMissed => direction == CallDirection.missed;
}

enum CallType { voice, video }

enum CallDirection { incoming, outgoing, missed }

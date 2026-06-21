import 'chat_message.dart';
import 'user_profile.dart';

/// A conversation: either 1-on-1 or group.
class Chat {
  final String id;
  final String title;
  final String? avatarUrl;
  final bool isGroup;
  final List<UserProfile> participants;
  final ChatMessage? lastMessage;
  final int unreadCount;

  const Chat({
    required this.id,
    required this.title,
    this.avatarUrl,
    this.isGroup = false,
    this.participants = const [],
    this.lastMessage,
    this.unreadCount = 0,
  });

  String get subtitle => lastMessage?.text ?? 'Say hi to $title!';
}

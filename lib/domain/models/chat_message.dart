/// A single chat message in a conversation.
class ChatMessage {
  final String id;
  final String chatId;
  final String senderId;
  final String text;
  final DateTime sentAt;
  final MessageStatus status;

  const ChatMessage({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.text,
    required this.sentAt,
    this.status = MessageStatus.read,
  });

  bool get isMine => senderId == 'me';
}

enum MessageStatus { sending, sent, delivered, read }

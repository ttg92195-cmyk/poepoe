import '../../domain/models/call_entry.dart';
import '../../domain/models/chat.dart';
import '../../domain/models/chat_message.dart';
import '../../domain/models/status_entry.dart';
import '../../domain/models/user_profile.dart';

/// Mock data used in step 1 (no Firebase yet).
/// Replaced with Firestore streams in step 3.
class MockData {
  MockData._();

  static final currentUser = UserProfile.mock(
    id: 'me',
    name: 'You',
    isOnline: true,
    status: 'Available',
  );

  static final List<UserProfile> contacts = [
    UserProfile.mock(
      id: 'u1',
      name: 'Aung Aung',
      isOnline: true,
      status: 'Hey there! I am using PoePoe.',
    ),
    UserProfile.mock(
      id: 'u2',
      name: 'Hla Hla',
      isOnline: false,
      status: 'Busy',
    ),
    UserProfile.mock(
      id: 'u3',
      name: 'Ko Zaw',
      isOnline: true,
      status: 'At work',
    ),
    UserProfile.mock(
      id: 'u4',
      name: 'Ma Su',
      isOnline: false,
      status: 'Available',
    ),
    UserProfile.mock(
      id: 'u5',
      name: 'PoePoe Team',
      isOnline: true,
      status: 'Official account',
    ),
  ];

  static final List<Chat> chats = [
    Chat(
      id: 'c1',
      title: 'Aung Aung',
      avatarUrl:
          'https://ui-avatars.com/api/?background=random&size=128&name=Aung+Aung',
      participants: [contacts[0]],
      lastMessage: ChatMessage(
        id: 'm1',
        chatId: 'c1',
        senderId: 'u1',
        text: 'Hey! Are you free tonight?',
        sentAt: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      unreadCount: 2,
    ),
    Chat(
      id: 'c2',
      title: 'Hla Hla',
      avatarUrl:
          'https://ui-avatars.com/api/?background=random&size=128&name=Hla+Hla',
      participants: [contacts[1]],
      lastMessage: ChatMessage(
        id: 'm2',
        chatId: 'c2',
        senderId: 'me',
        text: 'See you tomorrow then!',
        sentAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      unreadCount: 0,
    ),
    Chat(
      id: 'c3',
      title: 'Ko Zaw',
      avatarUrl:
          'https://ui-avatars.com/api/?background=random&size=128&name=Ko+Zaw',
      participants: [contacts[2]],
      lastMessage: ChatMessage(
        id: 'm3',
        chatId: 'c3',
        senderId: 'u3',
        text: 'Thanks bro!',
        sentAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      unreadCount: 0,
    ),
    Chat(
      id: 'c4',
      title: 'Ma Su',
      avatarUrl:
          'https://ui-avatars.com/api/?background=random&size=128&name=Ma+Su',
      participants: [contacts[3]],
      lastMessage: ChatMessage(
        id: 'm4',
        chatId: 'c4',
        senderId: 'u4',
        text: 'Did you finish the design?',
        sentAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      unreadCount: 1,
    ),
    Chat(
      id: 'c5',
      title: 'PoePoe Team',
      avatarUrl:
          'https://ui-avatars.com/api/?background=random&size=128&name=PoePoe',
      isGroup: true,
      participants: [contacts[4]],
      lastMessage: ChatMessage(
        id: 'm5',
        chatId: 'c5',
        senderId: 'u5',
        text: 'Welcome to PoePoe Chat! 🎉',
        sentAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      unreadCount: 0,
    ),
  ];

  static final Map<String, List<ChatMessage>> messagesByChat = {
    'c1': [
      ChatMessage(
        id: 'm1a',
        chatId: 'c1',
        senderId: 'u1',
        text: 'Hey bro!',
        sentAt: DateTime.now().subtract(const Duration(minutes: 10)),
      ),
      ChatMessage(
        id: 'm1b',
        chatId: 'c1',
        senderId: 'u1',
        text: 'Are you free tonight?',
        sentAt: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
    ],
    'c2': [
      ChatMessage(
        id: 'm2a',
        chatId: 'c2',
        senderId: 'u2',
        text: 'Tomorrow works for me',
        sentAt: DateTime.now().subtract(const Duration(hours: 2, minutes: 5)),
      ),
      ChatMessage(
        id: 'm2b',
        chatId: 'c2',
        senderId: 'me',
        text: 'See you tomorrow then!',
        sentAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
    ],
    'c3': [
      ChatMessage(
        id: 'm3a',
        chatId: 'c3',
        senderId: 'me',
        text: 'Sent the files',
        sentAt: DateTime.now().subtract(const Duration(hours: 5, minutes: 2)),
      ),
      ChatMessage(
        id: 'm3b',
        chatId: 'c3',
        senderId: 'u3',
        text: 'Thanks bro!',
        sentAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
    ],
    'c4': [
      ChatMessage(
        id: 'm4a',
        chatId: 'c4',
        senderId: 'u4',
        text: 'Did you finish the design?',
        sentAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ],
    'c5': [
      ChatMessage(
        id: 'm5a',
        chatId: 'c5',
        senderId: 'u5',
        text: 'Welcome to PoePoe Chat! 🎉',
        sentAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      ChatMessage(
        id: 'm5b',
        chatId: 'c5',
        senderId: 'u5',
        text: 'This is a placeholder app built with Flutter. Real-time messaging is coming in step 3.',
        sentAt: DateTime.now().subtract(const Duration(days: 2, minutes: 1)),
      ),
    ],
  };

  /// Mock recent calls for the Calls tab.
  static final List<CallEntry> calls = [
    CallEntry(
      id: 'call1',
      name: 'Aung Aung',
      avatarUrl:
          'https://ui-avatars.com/api/?background=random&size=128&name=Aung+Aung',
      type: CallType.voice,
      direction: CallDirection.incoming,
      at: DateTime.now().subtract(const Duration(minutes: 18)),
      duration: const Duration(minutes: 4, seconds: 22),
    ),
    CallEntry(
      id: 'call2',
      name: 'Hla Hla',
      avatarUrl:
          'https://ui-avatars.com/api/?background=random&size=128&name=Hla+Hla',
      type: CallType.video,
      direction: CallDirection.missed,
      at: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    CallEntry(
      id: 'call3',
      name: 'Ko Zaw',
      avatarUrl:
          'https://ui-avatars.com/api/?background=random&size=128&name=Ko+Zaw',
      type: CallType.voice,
      direction: CallDirection.outgoing,
      at: DateTime.now().subtract(const Duration(hours: 8)),
      duration: const Duration(minutes: 1, seconds: 12),
    ),
    CallEntry(
      id: 'call4',
      name: 'Ma Su',
      avatarUrl:
          'https://ui-avatars.com/api/?background=random&size=128&name=Ma+Su',
      type: CallType.video,
      direction: CallDirection.outgoing,
      at: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
      duration: const Duration(minutes: 12, seconds: 5),
    ),
    CallEntry(
      id: 'call5',
      name: 'PoePoe Team',
      avatarUrl:
          'https://ui-avatars.com/api/?background=random&size=128&name=PoePoe',
      type: CallType.voice,
      direction: CallDirection.incoming,
      at: DateTime.now().subtract(const Duration(days: 2)),
      duration: const Duration(seconds: 47),
    ),
  ];

  /// Mock status / stories for the Status tab.
  static final List<StatusEntry> myStatus = [
    StatusEntry(
      id: 'my0',
      name: 'You',
      avatarUrl: currentUser.avatarUrl,
      caption: 'Tap to add status',
      at: DateTime.now(),
    ),
  ];

  static final List<StatusEntry> recentStatuses = [
    StatusEntry(
      id: 's1',
      name: 'Aung Aung',
      avatarUrl:
          'https://ui-avatars.com/api/?background=random&size=128&name=Aung+Aung',
      caption: 'Good morning ☀️',
      at: DateTime.now().subtract(const Duration(minutes: 25)),
    ),
    StatusEntry(
      id: 's2',
      name: 'Ko Zaw',
      avatarUrl:
          'https://ui-avatars.com/api/?background=random&size=128&name=Ko+Zaw',
      caption: 'At the office 💻',
      at: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    StatusEntry(
      id: 's3',
      name: 'Ma Su',
      avatarUrl:
          'https://ui-avatars.com/api/?background=random&size=128&name=Ma+Su',
      caption: 'Lunch time!',
      at: DateTime.now().subtract(const Duration(hours: 5)),
      viewed: true,
    ),
  ];

  static final List<StatusEntry> viewedStatuses = [
    StatusEntry(
      id: 's4',
      name: 'Hla Hla',
      avatarUrl:
          'https://ui-avatars.com/api/?background=random&size=128&name=Hla+Hla',
      caption: 'Weekend vibes',
      at: DateTime.now().subtract(const Duration(days: 1)),
      viewed: true,
    ),
  ];
}

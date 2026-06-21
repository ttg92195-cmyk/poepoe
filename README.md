# PoePoe Chat

A modern Flutter messaging app — built step-by-step. This repository is the live
codebase for the PoePoe Chat project, currently on **Step 2 (tabs + tap feedback)**.

## Stack

| Layer       | Choice                            |
| ----------- | --------------------------------- |
| UI          | Flutter + Material 3              |
| Routing     | go_router                         |
| State       | Riverpod (wired, used in step 3)  |
| Fonts       | Google Fonts (Plus Jakarta Sans)  |
| Backend     | Firebase (wired in step 3)        |
| Android     | Kotlin + Gradle (auto-generated)  |

## Project structure

```
lib/
├── main.dart                  # App entry
├── core/
│   ├── constants/             # App-wide constants
│   ├── routing/               # go_router config
│   └── theme/                 # Material 3 theme + colors
├── data/
│   └── mock/                  # Mock data (replaced by Firestore later)
├── domain/
│   └── models/                # Plain models: UserProfile, Chat, ChatMessage, CallEntry, StatusEntry
├── features/
│   ├── chats/                 # Chats list screen
│   ├── chat_room/             # Single conversation screen
│   ├── calls/                 # Calls tab (recent + new call sheet)
│   ├── status/                # Status tab (my status + recent + viewed)
│   ├── main/                  # Bottom-nav shell (4 tabs)
│   └── profile/               # Profile + settings screen
└── widgets/                   # Reusable widgets (avatar, feedback helpers)
```

## Step roadmap

| Step | Goal                                                | Status |
| ---- | --------------------------------------------------- | ------ |
| 1    | Skeleton + theme + bottom nav + mock screens        | ✅      |
| 2    | Tabs (Calls + Status), tap feedback, working composer | ✅      |
| 3    | Login / register UI + Firebase Auth                 | ⏳      |
| 4    | Real-time chat with Firestore                       | ⏳      |
| 5    | Profile editing (cloud), presence, typing indicator | ⏳      |
| 6    | Push notifications (FCM) + polish                   | ⏳      |
| 7    | Release signing + Play Store listing                | ⏳      |

## What works in Step 2

- **4 tabs**: Chats, Status, Calls, Profile
- **Chat composer**: type a message and tap send — the message appears in the chat with a "sent → read" tick animation
- **Auto-reply**: messages sent to "PoePoe Team" get an auto-reply after ~1 second
- **Search**: tap the search icon on Chats to filter your conversations
- **New chat sheet**: tap the edit icon to pick a contact to chat with
- **New call sheet**: tap the + on Calls to pick a contact to call (shows toast)
- **Edit profile**: tap "Edit profile" on Profile to change your name and status
- **Attach sheet**: tap + in chat to see attachment options (photo/video/audio/doc)
- **Emoji picker**: tap the smiley in chat to insert emojis
- **Clear chat**: in a chat, ⋮ → Clear chat actually empties the conversation
- **Theme dropdown**: Profile → Dark mode lets you preview Light/Dark/System
- **Coming soon toasts**: every unimplemented button shows a snackbar instead of doing nothing

## Downloading the APK

Every push to `main` triggers the **Build Release APK** GitHub Action.

1. Open the **Actions** tab: https://github.com/ttg92195-cmyk/poepoe/actions
2. Click the latest successful run.
3. Scroll to **Artifacts** → download `poepoe-release-apk`.
4. Unzip and install `poepoe-<sha>.apk` on an Android device
   (you may need to enable "Install from unknown sources").

> Note: the APK is signed with the debug key in steps 1–6. A proper release
> keystore is configured in step 7.

## Local development (optional)

If you want to run the project locally:

```bash
flutter create --org com.poepoe --project-name poepoe .
flutter pub get
flutter run
```

The first command only fills in missing Android/iOS/web scaffolding files;
the hand-written `lib/` source files in this repo are preserved.


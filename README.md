# PoePoe Chat

A modern Flutter messaging app — built step-by-step. This repository is the live
codebase for the PoePoe Chat project, currently on **Step 1 (project skeleton +
GitHub Actions)**.

## Stack

| Layer       | Choice                            |
| ----------- | --------------------------------- |
| UI          | Flutter + Material 3              |
| Routing     | go_router                         |
| State       | Riverpod (wired, used in step 2)  |
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
│   └── mock/                  # Step-1 mock data (replaced by Firestore later)
├── domain/
│   └── models/                # Plain models: UserProfile, Chat, ChatMessage
├── features/
│   ├── chats/                 # Chats list screen
│   ├── chat_room/             # Single conversation screen
│   ├── main/                  # Bottom-nav shell
│   └── profile/               # Profile + settings screen
└── widgets/                   # Reusable widgets (avatar, ...)
```

## Step roadmap

| Step | Goal                                                | Status |
| ---- | --------------------------------------------------- | ------ |
| 1    | Skeleton + theme + bottom nav + mock screens        | ✅      |
| 2    | Login / register UI + Firebase Auth                 | ⏳      |
| 3    | Real-time chat with Firestore                       | ⏳      |
| 4    | Profile editing, presence, typing indicator         | ⏳      |
| 5    | Push notifications (FCM) + polish                   | ⏳      |
| 6    | Release signing + Play Store listing                | ⏳      |

## Downloading the APK

Every push to `main` triggers the **Build Release APK** GitHub Action.

1. Open the **Actions** tab: https://github.com/ttg92195-cmyk/poepoe/actions
2. Click the latest successful run.
3. Scroll to **Artifacts** → download `poepoe-release-apk`.
4. Unzip and install `poepoe-<sha>.apk` on an Android device
   (you may need to enable "Install from unknown sources").

> Note: the APK is signed with the debug key in step 1. A proper release
> keystore is configured in step 6.

## Local development (optional)

If you want to run the project locally:

```bash
flutter create --org com.poepoe --project-name poepoe .
flutter pub get
flutter run
```

The first command only fills in missing Android/iOS/web scaffolding files;
the hand-written `lib/` source files in this repo are preserved.

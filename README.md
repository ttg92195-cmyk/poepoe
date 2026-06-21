# PoePoe Chat

A modern Flutter messaging app — built step-by-step. This repository is the live
codebase for the PoePoe Chat project, currently on **Step 3 (Firebase Auth + Login UI)**.

## Stack

| Layer       | Choice                            |
| ----------- | --------------------------------- |
| UI          | Flutter + Material 3              |
| Routing     | go_router (auth-gated)            |
| State       | Riverpod                          |
| Fonts       | Google Fonts (Plus Jakarta Sans)  |
| Backend     | Firebase (Auth enabled, Firestore wired in step 4) |
| Android     | Kotlin + Gradle (auto-generated + Firebase patch) |

## Project structure

```
lib/
├── main.dart                  # App entry (Firebase init)
├── core/
│   ├── constants/             # App-wide constants
│   ├── routing/               # go_router config (auth redirect)
│   └── theme/                 # Material 3 theme + colors
├── data/
│   ├── mock/                  # Mock data (replaced by Firestore in step 4)
│   └── services/
│       └── auth_service.dart  # Wraps firebase_auth
├── domain/
│   └── models/                # Plain models: UserProfile, Chat, ChatMessage, CallEntry, StatusEntry
├── features/
│   ├── auth/                  # Login + Register + shared layout
│   ├── chats/                 # Chats list screen
│   ├── chat_room/             # Single conversation screen
│   ├── calls/                 # Calls tab
│   ├── status/                # Status tab
│   ├── main/                  # Bottom-nav shell (4 tabs)
│   └── profile/               # Profile + settings screen (with logout)
├── providers/
│   └── auth_providers.dart    # Riverpod providers for auth state
└── widgets/                   # Reusable widgets (avatar, feedback helpers)
```

## Step roadmap

| Step | Goal                                                | Status |
| ---- | --------------------------------------------------- | ------ |
| 1    | Skeleton + theme + bottom nav + mock screens        | ✅      |
| 2    | Tabs (Calls + Status), tap feedback, working composer | ✅      |
| 3    | Login / register UI + Firebase Auth                 | ✅      |
| 4    | Real-time chat with Firestore                       | ⏳      |
| 5    | Profile editing (cloud), presence, typing indicator | ⏳      |
| 6    | Push notifications (FCM) + polish                   | ⏳      |
| 7    | Release signing + Play Store listing                | ⏳      |

## What works in Step 3

- **Login screen** — sign in with email + password
- **Register screen** — create a new account with name, email, password
- **Auth state routing** — GoRouter automatically redirects:
  - Signed-out users → /login
  - Signed-in users on /login or /register → /chats
- **Persistence** — Firebase persists the session; closing and reopening the app keeps you signed in
- **Logout** — Profile → Log out actually signs you out and returns to /login
- **Edit profile** — changes display name and updates Firebase Auth in the background
- **Forgot password** — sends a reset email via Firebase
- **Friendly error messages** — invalid-email, weak-password, email-already-in-use, etc. are translated
- **Loading states** — buttons show spinners during async calls
- **All step-2 features** — 4 tabs, working composer, tap feedback, etc. (still use mock data until step 4)

## Firebase setup

The repo is pre-configured to talk to a Firebase project. The configuration file
`android/app/google-services.json` is committed (it contains only public config).

In CI, after `flutter create .` regenerates the default Gradle files, the
`scripts/patch_firebase.sh` script injects the Google Services plugin into
`android/build.gradle` and `android/app/build.gradle`. This is what enables
`firebase_core`, `firebase_auth`, and `cloud_firestore` to compile.

## Downloading the APK

Every push to `main` triggers the **Build Release APK** GitHub Action.

1. Open the **Actions** tab: https://github.com/ttg92195-cmyk/poepoe/actions
2. Click the latest successful run.
3. Scroll to **Artifacts** → download `poepoe-release-apk`.
4. Unzip and install `poepoe-<sha>.apk` on an Android device
   (you may need to enable "Install from unknown sources").

## Local development (optional)

```bash
flutter create --org com.poepoe --project-name poepoe .
bash scripts/patch_firebase.sh .
flutter pub get
flutter run
```

The first command only fills in missing Android/iOS/web scaffolding files;
the hand-written `lib/` source files in this repo are preserved.



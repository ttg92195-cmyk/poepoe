#!/usr/bin/env bash
# Patch the auto-generated Android Gradle files to enable Firebase.
#
# Context: in CI we run `flutter create .` which generates the default
# android/{build.gradle,app/build.gradle,settings.gradle} files. These
# default files do NOT include the Google Services plugin. This script
# injects the necessary lines so `flutter build apk` can resolve
# Firebase plugins.
#
# Idempotent: running it twice is safe.
set -euo pipefail

REPO_ROOT="${1:-.}"
ANDROID_DIR="$REPO_ROOT/android"
APP_DIR="$ANDROID_DIR/app"
GRADLE_PLUGIN_VER="4.4.2"

if [[ ! -f "$APP_DIR/google-services.json" ]]; then
  echo "[patch_firebase] ERROR: $APP_DIR/google-services.json not found."
  echo "                  Did you forget to commit it?"
  exit 1
fi

# ---- 1. Patch android/build.gradle (add classpath) ----
ROOT_GRADLE="$ANDROID_DIR/build.gradle"
echo "[patch_firebase] Patching $ROOT_GRADLE"
if ! grep -q "com.google.gms:google-services" "$ROOT_GRADLE"; then
  python3 - "$ROOT_GRADLE" "$GRADLE_PLUGIN_VER" <<'PY'
import sys
path, ver = sys.argv[1], sys.argv[2]
src = open(path).read()
needle = "dependencies {"
if needle in src:
    src = src.replace(
        needle,
        f"{needle}\n        classpath 'com.google.gms:google-services:{ver}'",
        1,
    )
open(path, "w").write(src)
PY
  echo "[patch_firebase]   added classpath entry"
else
  echo "[patch_firebase]   already patched, skipping"
fi

# ---- 2. Patch android/app/build.gradle (apply plugin) ----
APP_GRADLE="$APP_DIR/build.gradle"
echo "[patch_firebase] Patching $APP_GRADLE"
if ! grep -q "com.google.gms.google-services" "$APP_GRADLE"; then
  printf "\n// Firebase: apply google-services plugin\napply plugin: 'com.google.gms.google-services'\n" >> "$APP_GRADLE"
  echo "[patch_firebase]   appended apply plugin line"
else
  echo "[patch_firebase]   already patched, skipping"
fi

echo "[patch_firebase] Done. Firebase gradle config is now active."

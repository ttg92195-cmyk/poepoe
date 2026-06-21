#!/usr/bin/env bash
# Patch the auto-generated Android Gradle files to enable Firebase.
#
# Flutter 3.x generates Kotlin DSL gradle files (settings.gradle.kts,
# build.gradle.kts, app/build.gradle.kts). This script:
#   1. Adds the Google Services plugin to settings.gradle.kts plugins block
#   2. Adds the classpath dependency to build.gradle.kts
#   3. Applies the plugin in app/build.gradle.kts
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

# ---- 1. Patch android/settings.gradle.kts (add plugin to plugins block) ----
SETTINGS_KTS="$ANDROID_DIR/settings.gradle.kts"
echo "[patch_firebase] Patching $SETTINGS_KTS"
if [[ -f "$SETTINGS_KTS" ]] && ! grep -q "com.google.gms.google-services" "$SETTINGS_KTS"; then
  python3 - "$SETTINGS_KTS" <<'PY'
import sys, re
path = sys.argv[1]
src = open(path).read()
# Add id("com.google.gms.google-services") version "4.4.2" apply false
# inside the plugins { } block.
m = re.search(r"plugins\s*\{", src)
if m:
    insert_pos = m.end()
    src = (
        src[:insert_pos]
        + '\n    id("com.google.gms.google-services") version "4.4.2" apply false'
        + src[insert_pos:]
    )
open(path, "w").write(src)
PY
  echo "[patch_firebase]   added google-services plugin to settings.gradle.kts"
else
  echo "[patch_firebase]   settings.gradle.kts missing or already patched"
fi

# ---- 2. Patch android/build.gradle.kts (no-op: handled by settings.gradle.kts) ----
ROOT_KTS="$ANDROID_DIR/build.gradle.kts"
echo "[patch_firebase] (no changes needed in $ROOT_KTS — plugins declared in settings.gradle.kts)"

# ---- 3. Patch android/app/build.gradle.kts (apply plugin at end) ----
APP_KTS="$APP_DIR/build.gradle.kts"
echo "[patch_firebase] Patching $APP_KTS"
if [[ -f "$APP_KTS" ]] && ! grep -q "com.google.gms.google-services" "$APP_KTS"; then
  printf '\n// Firebase: apply google-services plugin\napply(plugin = "com.google.gms.google-services")\n' >> "$APP_KTS"
  echo "[patch_firebase]   appended apply(plugin = ...) line"
else
  echo "[patch_firebase]   app/build.gradle.kts missing or already patched"
fi

echo "[patch_firebase] Done. Firebase gradle config is now active."

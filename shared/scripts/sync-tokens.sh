#!/usr/bin/env bash
# Sync generated token files from liulian-design-system/dist/ to each platform.
# Run from liulian-mobile/ root.

set -euo pipefail

REPO_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
DS_DIR="${REPO_DIR}/../liulian-design-system"
DIST="${DS_DIR}/dist"

if [[ ! -d "${DIST}" ]]; then
  echo "ERROR: ${DIST} does not exist."
  echo "Run 'cd ${DS_DIR} && node scripts/build.mjs' first."
  exit 1
fi

echo "→ sync tokens from ${DIST}"

# iOS
IOS_TARGET="${REPO_DIR}/ios/LiulianUI/Sources/LiulianUI/Tokens.swift"
cp "${DIST}/Tokens.swift" "${IOS_TARGET}"
echo "  ✓ iOS:     ${IOS_TARGET}"

# Android
AND_TARGET="${REPO_DIR}/android/liulian-ui/src/main/kotlin/io/liulian/ui/Tokens.kt"
cp "${DIST}/Tokens.kt" "${AND_TARGET}"
echo "  ✓ Android: ${AND_TARGET}"

# HarmonyOS
HAR_TARGET="${REPO_DIR}/harmony/liulian_ui/src/main/ets/components/tokens.ets"
cp "${DIST}/tokens.ets" "${HAR_TARGET}"
echo "  ✓ Harmony: ${HAR_TARGET}"

# Shared cache (for VR tools to read)
mkdir -p "${REPO_DIR}/shared/design-tokens"
cp "${DIST}/"* "${REPO_DIR}/shared/design-tokens/"
echo "  ✓ cache:   ${REPO_DIR}/shared/design-tokens/"

echo "✓ done"

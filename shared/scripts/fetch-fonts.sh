#!/usr/bin/env bash
# Download Fraunces, Switzer, and JetBrains Mono into each platform's font directory.
# Fonts embedded in app bundles to guarantee identical rendering across platforms (pixel parity).

set -euo pipefail

REPO_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

echo "→ download fonts to ${TMP}"

# 1. Fraunces — variable-axis font with stylistic alternates (incl. WONK for italic alt-U).
# Source: google/fonts repo (SIL OFL — embedding allowed).
# The fonts.google.com/download endpoint returns HTML, so we hit the raw .ttf via GitHub.
mkdir -p "${TMP}/fraunces"
curl -sSL -o "${TMP}/fraunces/Fraunces.ttf" \
  "https://github.com/google/fonts/raw/main/ofl/fraunces/Fraunces%5BSOFT%2CWONK%2Copsz%2Cwght%5D.ttf"
FRAUNCES_TTF="${TMP}/fraunces/Fraunces.ttf"

# 2. Switzer — Fontshare (Indian Type Foundry)
# License: SIL OFL via Fontshare
curl -sSL -o "${TMP}/switzer.zip" \
  "https://api.fontshare.com/v2/fonts/download/switzer"
unzip -q "${TMP}/switzer.zip" -d "${TMP}/switzer"
SWITZER_REGULAR=$(find "${TMP}/switzer" -name "Switzer-Regular.otf" -o -name "Switzer-Regular.ttf" | head -1)
SWITZER_MEDIUM=$(find "${TMP}/switzer" -name "Switzer-Medium.otf" -o -name "Switzer-Medium.ttf" | head -1)

# 3. JetBrains Mono — Google Fonts / JetBrains
# License: SIL OFL
curl -sSL -o "${TMP}/jetbrains.zip" \
  "https://download.jetbrains.com/fonts/JetBrainsMono-2.304.zip"
unzip -q "${TMP}/jetbrains.zip" -d "${TMP}/jetbrains"
JBM_REGULAR=$(find "${TMP}/jetbrains" -name "JetBrainsMono-Regular.ttf" | head -1)
JBM_MEDIUM=$(find "${TMP}/jetbrains" -name "JetBrainsMono-Medium.ttf" | head -1)

# Distribute to each platform
copy_fonts() {
  local target_dir="$1"
  mkdir -p "${target_dir}"
  cp "${FRAUNCES_TTF}" "${target_dir}/Fraunces.ttf"
  cp "${SWITZER_REGULAR}" "${target_dir}/Switzer-Regular.${SWITZER_REGULAR##*.}"
  cp "${SWITZER_MEDIUM}" "${target_dir}/Switzer-Medium.${SWITZER_MEDIUM##*.}"
  cp "${JBM_REGULAR}" "${target_dir}/JetBrainsMono-Regular.ttf"
  cp "${JBM_MEDIUM}" "${target_dir}/JetBrainsMono-Medium.ttf"
  echo "  ✓ ${target_dir}"
}

copy_fonts "${REPO_DIR}/ios/LiulianApp/Resources/Fonts"
# Android: library module owns fonts (referenced via io.liulian.ui.R.font.*)
# Android file naming must be lowercase + underscores (R.font.* rules).
copy_fonts_android() {
  local target_dir="$1"
  mkdir -p "${target_dir}"
  cp "${FRAUNCES_TTF}" "${target_dir}/fraunces.ttf"
  cp "${SWITZER_REGULAR}" "${target_dir}/switzer_regular.${SWITZER_REGULAR##*.}"
  cp "${SWITZER_MEDIUM}" "${target_dir}/switzer_medium.${SWITZER_MEDIUM##*.}"
  cp "${JBM_REGULAR}" "${target_dir}/jetbrains_mono_regular.ttf"
  cp "${JBM_MEDIUM}" "${target_dir}/jetbrains_mono_medium.ttf"
  echo "  ✓ ${target_dir}"
}
copy_fonts_android "${REPO_DIR}/android/liulian-ui/src/main/res/font"
copy_fonts "${REPO_DIR}/harmony/entry/src/main/resources/rawfile/fonts"

echo "✓ fonts installed in 3 platforms"
echo ""
echo "Next steps:"
echo "  - iOS:     add the .ttf files to Info.plist 'UIAppFonts' (already templated in ios/LiulianApp/Info.plist)"
echo "  - Android: Android picks up res/font automatically — refer to fonts via io.liulian.ui.R.font.fraunces etc."
echo "  - Harmony: register fonts via app.ets resources (see harmony/entry/src/main/resources/base/element/font.json)"

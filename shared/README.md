# liulian-mobile / shared

Cross-platform assets and scripts.

## Layout

- `design-tokens/` — copied from `../../liulian-design-system/dist/` by `scripts/sync-tokens.sh` (gitignored as a cache; source of truth is in liulian-design-system)
- `refs/` — UI-spec reference images, also copied from design-system
- `scripts/` — automation
  - `sync-tokens.sh` — pull latest token outputs into each platform's source tree
  - `fetch-fonts.sh` — download Fraunces / Switzer / JetBrains Mono `.ttf` files into each platform's font directory
  - `vr-capture.sh` — take GalleryView screenshots on iOS Simulator + Android emulator + HarmonyOS emulator (requires those platforms' SDKs installed)
  - `vr-diff.sh` — generate 4-grid PNG comparisons of web + 3 mobile platforms

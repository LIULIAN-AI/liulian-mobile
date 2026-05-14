# LIULIAN HarmonyOS app

ArkTS + ArkUI declarative. Target HarmonyOS NEXT API 12+ (2024-2025 stack).

## Layout

```
harmony/
├── build-profile.json5      — workspace build config
├── oh-package.json5         — workspace package metadata
├── entry/                   — App module
│   ├── build-profile.json5
│   ├── oh-package.json5
│   └── src/main/
│       ├── module.json5     — module manifest (abilities, permissions)
│       ├── ets/
│       │   ├── entryability/EntryAbility.ets
│       │   └── pages/
│       │       ├── Index.ets     — first page (tab bar host)
│       │       ├── Home.ets
│       │       └── Gallery.ets
│       └── resources/
│           ├── base/element/  — strings, colors
│           ├── base/profile/main_pages.json
│           └── rawfile/fonts/  — embedded fonts (gitignored)
└── liulian_ui/              — UI library module (HAR)
    ├── oh-package.json5
    ├── build-profile.json5
    └── src/main/ets/components/
        ├── tokens.ets         — auto-generated (synced from liulian-design-system)
        ├── LiulianFont.ets
        ├── LiulianText.ets
        ├── LiulianButton.ets
        ├── LiulianCard.ets
        ├── LiulianGallery.ets
        └── index.ets          — barrel export
```

## Setup

```bash
# 1. Install DevEco Studio 5.0+ (https://developer.huawei.com/consumer/cn/deveco-studio/)
# 2. Configure HarmonyOS SDK in DevEco preferences → SDK Manager
# 3. Sync fonts + tokens
bash ../shared/scripts/fetch-fonts.sh
bash ../shared/scripts/sync-tokens.sh

# 4. Open harmony/ in DevEco Studio
#    File → Open → select harmony/ folder
#    DevEco indexes and resolves dependencies automatically

# 5. Run
#    Pick an emulator (HarmonyOS NEXT API 12 — phone form factor)
#    Click ▶ Run
```

## Pixel-parity discipline (HarmonyOS specifics)

- **Don't use ArkUI's default `Button`, `TextInput` etc.** Use `Row`, `Column`, `Stack`, `Text` + custom `.onClick` handlers + custom press animation via `.animation({...})`.
- **Disable system press animation**: ArkUI's default press animation is a slight darken. Override via `.stateStyles({ pressed: { ...custom... } })`.
- **No raw numbers in `.fontSize()`, `.padding()`, `.borderRadius()`** — always reference `Colors.*` / `Spacing.*` / `Radius.*` from `tokens.ets`.
- **Fonts**: registered via app.ets `globalThis.fontFamilyConfig` from rawfile entries.

## Visual regression

DevEco supports component preview via `@Preview` decorator. Use `LiulianGallery` page in preview mode. Export preview screenshots via DevEco → save to `../shared/refs/harmony-Gallery.png`.

## Notes on the ArkUI ecosystem (2026 status)

- ArkUI uses the Stage Model (replaces FA model from pre-HarmonyOS 3.1).
- Declarative `@Component` and `@Entry` decorators define UI structurally; modifiers chain via `.foo(...)`.
- Animations use `.animation()` modifier with `{ duration, curve, iterations, playMode }` config.
- `curves.cubicBezierCurve(x1, y1, x2, y2)` from `@kit.ArkUI` gives a curve usable in `.animation({ curve: ... })`.

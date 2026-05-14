# LIULIAN Android app

Kotlin + Jetpack Compose. Min SDK 24, target 34. Android Gradle Plugin 8.5+.

## Layout

```
android/
├── settings.gradle.kts       — multi-module config (app + liulian-ui)
├── build.gradle.kts          — root build (just plugins manifest)
├── gradle.properties
├── gradle/libs.versions.toml — central version catalog
├── app/                      — App module (depends on liulian-ui)
│   ├── build.gradle.kts
│   └── src/main/
│       ├── AndroidManifest.xml
│       ├── java/io/liulian/app/
│       │   ├── MainActivity.kt   (@AndroidEntryPoint, sets up Compose)
│       │   ├── HomeScreen.kt
│       │   └── GalleryScreen.kt
│       └── res/
│           ├── font/             (gitignored, populated by shared/scripts/fetch-fonts.sh)
│           └── values/
│               ├── strings.xml
│               └── themes.xml    (Activity theme = NoActionBar)
└── liulian-ui/               — UI library module (used by app, and someday by other Android consumers)
    ├── build.gradle.kts
    └── src/main/
        ├── AndroidManifest.xml
        └── kotlin/io/liulian/ui/
            ├── Tokens.kt          — auto-generated (synced from liulian-design-system)
            ├── LiulianFont.kt     — Font helper registering Fraunces / Switzer / JBMono
            ├── LiulianText.kt
            ├── LiulianButton.kt
            ├── LiulianCard.kt
            └── LiulianGallery.kt
```

## Setup

```bash
# 1. (Once) install Android Studio Iguana or later
# 2. (Once) install JDK 17 (Android Gradle Plugin 8+ requires it)

# 3. Sync fonts + tokens
bash ../shared/scripts/fetch-fonts.sh
bash ../shared/scripts/sync-tokens.sh

# 4. Open `android/` in Android Studio
#    File → Open → select android/ folder → Trust project
#    Gradle sync runs automatically.

# 5. Run on emulator
./gradlew :app:installDebug

# Or, from Android Studio: pick Pixel 8 / API 34 emulator, ▶ Run
```

## Pixel-parity discipline (Android specifics)

- **Don't use Material 3 `Button`, `Card`, `Surface` etc.** Use Compose Foundation primitives (`Box`, `Row`, `Column`, `BasicText`) so we control rendering exactly.
- **Disable Material ripple**: every `Modifier.clickable(...)` MUST pass `indication = null` and use a custom `MutableInteractionSource`. We render our own press state via `transform: scale(0.98)`.
- **No `MaterialTheme.colorScheme.*`** in source — always use `LiulianTokens.Colors.*`.
- **No `dp`/`sp` literals** in source — `4.dp` ok inside `Tokens.kt` (it's generated), forbidden elsewhere.
- **Fonts via `R.font.*`** referenced by `LiulianFont`. NEVER use `FontFamily.SansSerif` / `FontFamily.Default`.

## Visual regression

Run the `:liulian-ui:liulianUiPreviewScreenshots` task (after adding Paparazzi or Shot — see `shared/scripts/vr-capture.sh`).

```bash
./gradlew :liulian-ui:liulianUiPreviewScreenshots
# Outputs to liulian-ui/build/reports/screenshots/
# Copy desired ones to shared/refs/ for VR diff.
```

# HarmonyOS NEXT testing — what's possible without a Mac/Windows DevEco

Researched 2026-05-15. The HarmonyOS toolchain is the most opinionated of the three platforms; this doc captures what works and what doesn't.

## TL;DR

| What you want | Where it works | Notes |
|---|---|---|
| Build `.hap` from CLI | ✅ Linux / macOS / Windows | via `hvigorw assembleHap` after installing HarmonyOS Command Line Tools |
| Preview ArkUI components as PNG (no emulator) | ❌ Only inside DevEco Studio | No standalone CLI previewer as of 2026-05; component preview is IDE-bound |
| Run on emulator | ⚠️ Windows / macOS (Linux beta thin) | DevEco bundles the emulator; standalone emulator not officially supported on Linux |
| Sign + publish to AppGallery | ⚠️ Effectively Windows / macOS | Signing keys generation tied to DevEco / AGC Console |
| **Cloud test on real Mate 60 Pro + family** | ✅ Anywhere (paid) | Huawei AGC Cloud Test — automated UI test on real device farm |

The **biggest gap** is preview/snapshot: ArkUI 没有 Paparazzi 等价物. The fastest VR baseline you'll get is hand-export from DevEco's component preview window.

## 1. Linux CLI build path (recommended for CI)

### Get the tools

The HarmonyOS Command Line Tools require a verified Huawei developer account (often a Chinese-mainland account). Steps:

1. Register at https://developer.huawei.com (or developer.huawei.com/consumer/cn)
2. Complete identity verification (Chinese citizen ID for full access)
3. Download "Command Line Tools for HarmonyOS NEXT" — Linux .zip
   - Direct doc link: https://developer.huawei.com/consumer/en/doc/harmonyos-guides/ide-commandline-get
4. Or use the third-party CLI helper `chawyehsu/hdx`:
   ```bash
   npm i -g @chawyehsu/hdx
   hdx get command-line-tools-for-hmos --platform linux
   ```

### Install and configure

Extract to e.g. `~/harmony-cli/`. Then:

```bash
# In .bashrc / .zshrc:
export DEVECO_SDK_HOME=$HOME/harmony-cli/sdk
export NODE_HOME=$HOME/harmony-cli/tool/node
export PATH="$HOME/harmony-cli/bin:$NODE_HOME/bin:$PATH"

# Verify
hvigor --version
hdc list targets    # connected devices (none expected yet)
```

### Build the LIULIAN HarmonyOS app

```bash
cd liulian-mobile/harmony
hvigorw clean
hvigorw assembleHap

# Output: harmony/entry/build/default/outputs/default/entry-default-signed.hap
# (or -unsigned if no signing key configured)
```

### What this verifies

- All `.ets` files compile (real ArkTS compiler approval)
- `entry` and `liulian_ui` module resolution works
- Resources (fonts, strings, colors) resolve
- module.json5 manifest is valid

### What this does NOT verify

- ArkUI rendering correctness (no static preview from CLI)
- Animations / interactions
- Platform abilities (HMS push, location, etc.)

## 2. ArkUI VR snapshot — workaround

Since there's no headless ArkUI renderer, options for the "Android Paparazzi equivalent" are limited:

### Option A: DevEco previewer + manual export (recommended for solo dev)

1. Open `harmony/` in DevEco Studio (Windows or macOS)
2. Open `liulian_ui/src/main/ets/components/LiulianGallery.ets`
3. Add `@Preview` annotation above `struct LiulianGallery`
4. Click the "Component Preview" tab → renders interactively
5. Right-click preview canvas → Export Image → save as `shared/refs/harmony-Gallery.png`

### Option B: Cloud Test via AGC (paid, but covers real devices)

- https://developer.huawei.com/consumer/cn/services/cloudtest
- Upload `.hap` → runs on real Mate 60 / 70 / etc. → screenshots returned
- Cost: ~¥0.5 per device-minute
- Worth it for **real-device VR baseline** before shipping

### Option C: Wait for Hypium snapshot support

Huawei's testing framework Hypium has UI-element APIs but no PNG snapshot out of the box. There's a community feature request (no ETA).

## 3. CI workflow (stub)

GitHub Actions hosted runners don't have HarmonyOS tools. Options:

| Path | Setup |
|---|---|
| **Self-hosted Linux runner** | Install HarmonyOS Command Line Tools on a Linux box you control; register as a GitHub Actions runner |
| **Huawei CodeArts Pipeline** | Native HarmonyOS CI in Huawei's cloud; ¥0.5/min, integrates with AGC |
| **Local-only** | Run `hvigorw assembleHap` on your dev machine; commit `.hap` artifact under `dist/` (not ideal, but works for solo) |

A self-hosted runner workflow is committed at `.github/workflows/harmony-build.yml` (stub — enable by adding `runner.label: harmony-cli`).

## 4. Quick checklist for verifying LIULIAN HarmonyOS today

Without DevEco access (Linux-only):

```bash
# 1. Get HarmonyOS Command Line Tools (manual download per §1 above)

# 2. Sync
cd liulian-mobile
bash shared/scripts/sync-tokens.sh
bash shared/scripts/fetch-fonts.sh
cd harmony

# 3. Build
hvigorw clean
hvigorw assembleHap

# 4. Verify .hap produced
ls entry/build/default/outputs/default/*.hap
```

With DevEco access (Windows/macOS):

1. File → Open → `liulian-mobile/harmony/`
2. Wait for index + sync
3. Open `liulian_ui/.../LiulianGallery.ets`
4. Component Preview → Export → `shared/refs/harmony-Gallery.png`
5. ▶ Run → emulator or attached device

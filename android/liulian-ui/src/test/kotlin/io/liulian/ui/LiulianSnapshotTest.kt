package io.liulian.ui

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.ui.Modifier
import app.cash.paparazzi.DeviceConfig
import app.cash.paparazzi.Paparazzi
import io.liulian.tokens.LiulianTokens
import org.junit.Rule
import org.junit.Test

/**
 * Visual regression snapshots for LiulianUI components.
 *
 * Run:
 *   ./gradlew :liulian-ui:recordPaparazziDebug   # capture / update baselines
 *   ./gradlew :liulian-ui:verifyPaparazziDebug   # CI gate: fail if diff
 *
 * Output: PNGs under src/test/snapshots/images/ — commit these.
 */
class LiulianSnapshotTest {
    @get:Rule
    val paparazzi = Paparazzi(
        deviceConfig = DeviceConfig.PIXEL_5,
        theme = "android:Theme.Material.Light.NoActionBar",
        showSystemUi = false,
    )

    @Test
    fun text_all_variants() {
        paparazzi.snapshot {
            Column(
                modifier = Modifier
                    .fillMaxSize()
                    .background(LiulianTokens.Colors.canvasWarm)
                    .padding(LiulianTokens.Spacing.s6),
                verticalArrangement = Arrangement.spacedBy(LiulianTokens.Spacing.s3),
            ) {
                LiulianText("displayShort 56", variant = LiulianTextVariant.DisplayShort)
                LiulianText("heading 38", variant = LiulianTextVariant.Heading)
                LiulianText("title 28", variant = LiulianTextVariant.Title)
                LiulianText("subtitle 18", variant = LiulianTextVariant.Subtitle)
                LiulianText("body 13.5", variant = LiulianTextVariant.Body)
                LiulianText("bodyStrong 13.5/500", variant = LiulianTextVariant.BodyStrong)
                LiulianText("caption 10.5", variant = LiulianTextVariant.Caption, color = LiulianTokens.Colors.inkMuted)
                LiulianText("monoLabel uppercase", variant = LiulianTextVariant.MonoLabel, color = LiulianTokens.Colors.inkFaint)
            }
        }
    }

    @Test
    fun button_variants() {
        paparazzi.snapshot {
            Column(
                modifier = Modifier
                    .fillMaxSize()
                    .background(LiulianTokens.Colors.canvasWarm)
                    .padding(LiulianTokens.Spacing.s7),
                verticalArrangement = Arrangement.spacedBy(LiulianTokens.Spacing.s4),
            ) {
                // Variants on 2 rows so 411dp Pixel 5 width doesn't clip Danger
                Row(horizontalArrangement = Arrangement.spacedBy(LiulianTokens.Spacing.s3)) {
                    LiulianButton("Primary", onPress = {})
                    LiulianButton("Secondary", onPress = {}, variant = ButtonVariant.Secondary)
                }
                Row(horizontalArrangement = Arrangement.spacedBy(LiulianTokens.Spacing.s3)) {
                    LiulianButton("Ghost", onPress = {}, variant = ButtonVariant.Ghost)
                    LiulianButton("Danger", onPress = {}, variant = ButtonVariant.Danger)
                }
                // Sizes (compact)
                Row(horizontalArrangement = Arrangement.spacedBy(LiulianTokens.Spacing.s3)) {
                    LiulianButton("S", onPress = {}, size = ButtonSize.Sm)
                    LiulianButton("M", onPress = {}, size = ButtonSize.Md)
                    LiulianButton("L", onPress = {}, size = ButtonSize.Lg)
                }
                Row(horizontalArrangement = Arrangement.spacedBy(LiulianTokens.Spacing.s3)) {
                    LiulianButton("Loading", onPress = {}, loading = true)
                    LiulianButton("Disabled", onPress = {}, disabled = true)
                }
            }
        }
    }

    @Test
    fun card_variants() {
        paparazzi.snapshot {
            Column(
                modifier = Modifier
                    .fillMaxSize()
                    .background(LiulianTokens.Colors.canvasWarm)
                    .padding(LiulianTokens.Spacing.s6),
                verticalArrangement = Arrangement.spacedBy(LiulianTokens.Spacing.s3),
            ) {
                LiulianCard(size = CardSize.Compact) {
                    LiulianText("Compact card", variant = LiulianTextVariant.Title)
                    LiulianText("padding s4 (16)", variant = LiulianTextVariant.Body, color = LiulianTokens.Colors.inkMuted)
                }
                LiulianCard {
                    LiulianText("Default card", variant = LiulianTextVariant.Title)
                    LiulianText("padding s6 (24)", variant = LiulianTextVariant.Body, color = LiulianTokens.Colors.inkMuted)
                }
                LiulianCard(size = CardSize.Spacious) {
                    LiulianText("Spacious card", variant = LiulianTextVariant.Title)
                    LiulianText("padding s7 (32)", variant = LiulianTextVariant.Body, color = LiulianTokens.Colors.inkMuted)
                }
                LiulianCard(selected = true) {
                    LiulianText("Selected card", variant = LiulianTextVariant.Title)
                    LiulianText("border 2dp unibe red", variant = LiulianTextVariant.Body, color = LiulianTokens.Colors.inkMuted)
                }
            }
        }
    }

    @Test
    fun gallery_top() {
        // Captures the viewport-visible portion of the gallery (above the fold).
        paparazzi.snapshot {
            LiulianGallery()
        }
    }

    @Test
    fun input_variants() {
        paparazzi.snapshot {
            Column(
                modifier = Modifier
                    .fillMaxSize()
                    .background(LiulianTokens.Colors.canvasWarm)
                    .padding(LiulianTokens.Spacing.s6),
                verticalArrangement = Arrangement.spacedBy(LiulianTokens.Spacing.s4),
            ) {
                LiulianInput(value = "", onChange = {}, label = "Station", placeholder = "e.g. aare-bern")
                LiulianInput(value = "abc", onChange = {}, label = "Validated", errorText = "Must start with a letter")
                LiulianInput(value = "read-only", onChange = {}, label = "Readonly", readonly = true)
                LiulianInput(value = "disabled", onChange = {}, label = "Disabled", disabled = true)
            }
        }
    }

    @Test
    fun tab_default() {
        paparazzi.snapshot {
            Column(
                modifier = Modifier
                    .fillMaxSize()
                    .background(LiulianTokens.Colors.canvasWarm),
            ) {
                LiulianTab(
                    items = listOf(
                        LiulianTabItem("landing", "LANDING"),
                        LiulianTabItem("forecast", "FORECAST"),
                        LiulianTabItem("studio", "STUDIO"),
                    ),
                    activeId = "forecast",
                    onChange = {},
                )
            }
        }
    }

    @Test
    fun listitem_variants() {
        paparazzi.snapshot {
            Column(
                modifier = Modifier
                    .fillMaxSize()
                    .background(LiulianTokens.Colors.canvasWarm),
            ) {
                LiulianListItem(primary = "aare-bern", secondary = "142 cm · forecast +6", onPress = {}, variant = ListItemVariant.Navigation)
                LiulianListItem(primary = "rhein-rheinfelden", secondary = "78 cm · stable", onPress = {}, variant = ListItemVariant.Selectable, selected = true)
                LiulianListItem(primary = "ticino-bellinzona", secondary = "210 cm · -3 / 24h", onPress = {}, variant = ListItemVariant.MultiSelectable, selected = false)
                LiulianListItem(primary = "limmat-baden", secondary = "static, no chevron", onPress = {}, variant = ListItemVariant.Content)
            }
        }
    }
}

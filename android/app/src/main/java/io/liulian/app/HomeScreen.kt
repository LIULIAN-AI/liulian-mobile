package io.liulian.app

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.style.TextAlign
import io.liulian.tokens.LiulianTokens
import io.liulian.ui.ButtonSize
import io.liulian.ui.ButtonVariant
import io.liulian.ui.CardSize
import io.liulian.ui.LiulianButton
import io.liulian.ui.LiulianCard
import io.liulian.ui.LiulianText
import io.liulian.ui.LiulianTextVariant

/**
 * Home screen — mirrors the iOS HomeView and the web mobile-preview Home tab.
 * Pure Compose Foundation; no Material widgets.
 */
@Composable
fun HomeScreen(modifier: Modifier = Modifier) {
    var selected by remember { mutableStateOf("aare-bern") }

    Column(
        modifier =
            modifier
                .fillMaxSize()
                .background(LiulianTokens.Colors.canvasWarm)
                .verticalScroll(rememberScrollState())
                .padding(LiulianTokens.Spacing.s5),
        verticalArrangement = Arrangement.spacedBy(LiulianTokens.Spacing.s5),
    ) {
        Header()
        Headline()
        QuickActions()
        Stations(selected = selected, onSelect = { selected = it })
        Spacer(modifier = Modifier.height(LiulianTokens.Spacing.s9))
    }
}

@Composable
private fun Header() {
    Row(
        verticalAlignment = Alignment.CenterVertically,
        modifier = Modifier.fillMaxWidth(),
    ) {
        Column(modifier = Modifier.fillMaxWidth(0.7f)) {
            LiulianText("liulian · home", variant = LiulianTextVariant.MonoLabel, color = LiulianTokens.Colors.inkFaint)
            LiulianText("Forecast", variant = LiulianTextVariant.Heading)
        }
        Spacer(modifier = Modifier.size(LiulianTokens.Spacing.s3))
        LiulianButton("Search", onPress = {}, variant = ButtonVariant.Ghost, size = ButtonSize.Sm)
    }
}

@Composable
private fun Headline() {
    LiulianCard(size = CardSize.Spacious) {
        LiulianText("Aare-Bern", variant = LiulianTextVariant.Title)
        Row(
            verticalAlignment = Alignment.Bottom,
            modifier = Modifier.fillMaxWidth(),
        ) {
            LiulianText(
                "142 cm",
                variant = LiulianTextVariant.Display,
                color = LiulianTokens.Colors.inkCharcoal,
                modifier = Modifier.fillMaxWidth(0.7f),
            )
            Column(horizontalAlignment = Alignment.End) {
                LiulianText(
                    "+ 6 cm / 24h",
                    variant = LiulianTextVariant.Body,
                    color = LiulianTokens.Colors.unibeRedText,
                    align = TextAlign.End,
                )
                LiulianText(
                    "forecast",
                    variant = LiulianTextVariant.MonoLabel,
                    color = LiulianTokens.Colors.inkFaint,
                    align = TextAlign.End,
                )
            }
        }
    }
}

@Composable
private fun QuickActions() {
    LiulianText("quick actions", variant = LiulianTextVariant.MonoLabel, color = LiulianTokens.Colors.inkFaint)
    Row(horizontalArrangement = Arrangement.spacedBy(LiulianTokens.Spacing.s3)) {
        LiulianButton("Forecast", onPress = {})
        LiulianButton("Alerts", onPress = {}, variant = ButtonVariant.Secondary)
    }
}

@Composable
private fun Stations(
    selected: String,
    onSelect: (String) -> Unit,
) {
    LiulianText("stations", variant = LiulianTextVariant.MonoLabel, color = LiulianTokens.Colors.inkFaint)
    Column(verticalArrangement = Arrangement.spacedBy(LiulianTokens.Spacing.s3)) {
        listOf("aare-bern", "rhein-rheinfelden", "ticino-bellinzona").forEach { id ->
            LiulianCard(
                size = CardSize.Compact,
                interactive = true,
                selected = selected == id,
                onPress = { onSelect(id) },
            ) {
                LiulianText(id, variant = LiulianTextVariant.BodyStrong)
                LiulianText(
                    "142 cm · forecast +6",
                    variant = LiulianTextVariant.Caption,
                    color = LiulianTokens.Colors.inkMuted,
                )
            }
        }
    }
}

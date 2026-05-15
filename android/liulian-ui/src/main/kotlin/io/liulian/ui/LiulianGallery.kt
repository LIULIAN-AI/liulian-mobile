package io.liulian.ui

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import io.liulian.tokens.LiulianTokens

@Composable
fun LiulianGallery(modifier: Modifier = Modifier) {
    Column(
        modifier =
            modifier
                .fillMaxSize()
                .background(LiulianTokens.Colors.canvasWarm)
                .verticalScroll(rememberScrollState())
                .padding(LiulianTokens.Spacing.s6),
        verticalArrangement = Arrangement.spacedBy(LiulianTokens.Spacing.s8),
    ) {
        Header()
        SectionText()
        SectionButton()
        SectionCard()
        SectionInput()
        SectionTab()
        SectionListItem()
        Spacer(modifier = Modifier.height(LiulianTokens.Spacing.s10))
    }
}

@Composable
private fun SectionInput() {
    SectionTitle("LiulianInput")
    Column(verticalArrangement = Arrangement.spacedBy(LiulianTokens.Spacing.s4)) {
        LiulianInput(value = "", onChange = {}, label = "Station", placeholder = "e.g. aare-bern")
        LiulianInput(value = "abc", onChange = {}, label = "Validated", errorText = "Must start with a letter")
        LiulianInput(value = "read-only", onChange = {}, label = "Readonly", readonly = true)
    }
}

@Composable
private fun SectionTab() {
    SectionTitle("LiulianTab")
    var activeTab by remember { mutableStateOf("forecast") }
    LiulianTab(
        items = listOf(
            LiulianTabItem("landing", "LANDING"),
            LiulianTabItem("forecast", "FORECAST"),
            LiulianTabItem("studio", "STUDIO"),
        ),
        activeId = activeTab,
        onChange = { activeTab = it },
    )
}

@Composable
private fun SectionListItem() {
    SectionTitle("LiulianListItem")
    Column {
        LiulianListItem(primary = "aare-bern", secondary = "142 cm · forecast +6", onPress = {}, variant = ListItemVariant.Navigation)
        LiulianListItem(primary = "rhein-rheinfelden", secondary = "78 cm · stable", onPress = {}, variant = ListItemVariant.Selectable, selected = true)
        LiulianListItem(primary = "ticino-bellinzona", secondary = "210 cm · -3 / 24h", onPress = {}, variant = ListItemVariant.MultiSelectable, selected = false)
        LiulianListItem(primary = "limmat-baden", secondary = "static, no chevron", onPress = {}, variant = ListItemVariant.Content)
    }
}

@Composable
private fun Header() {
    Column(verticalArrangement = Arrangement.spacedBy(LiulianTokens.Spacing.s2)) {
        LiulianText("LIULIAN · Android", variant = LiulianTextVariant.MonoLabel, color = LiulianTokens.Colors.inkFaint)
        LiulianText("Component Gallery", variant = LiulianTextVariant.Heading)
        LiulianText(
            "Visual regression baseline. All variants × all states.",
            variant = LiulianTextVariant.Body,
            color = LiulianTokens.Colors.inkMuted,
        )
    }
}

@Composable
private fun SectionText() {
    SectionTitle("LiulianText")
    Column(verticalArrangement = Arrangement.spacedBy(LiulianTokens.Spacing.s3)) {
        LiulianText("display 96", variant = LiulianTextVariant.Display)
        LiulianText("displayShort 56", variant = LiulianTextVariant.DisplayShort)
        LiulianText("heading 38", variant = LiulianTextVariant.Heading)
        LiulianText("title 28", variant = LiulianTextVariant.Title)
        LiulianText("subtitle 18", variant = LiulianTextVariant.Subtitle)
        LiulianText("body 13.5", variant = LiulianTextVariant.Body)
        LiulianText("bodyStrong 13.5/500", variant = LiulianTextVariant.BodyStrong)
        LiulianText("caption 10.5", variant = LiulianTextVariant.Caption, color = LiulianTokens.Colors.inkMuted)
        LiulianText("monoLabel 10.5", variant = LiulianTextVariant.MonoLabel, color = LiulianTokens.Colors.inkFaint)
    }
}

@Composable
private fun SectionButton() {
    SectionTitle("LiulianButton")
    LiulianText("variants", variant = LiulianTextVariant.MonoLabel, color = LiulianTokens.Colors.inkFaint)
    Row(horizontalArrangement = Arrangement.spacedBy(LiulianTokens.Spacing.s3)) {
        LiulianButton("Primary", onPress = {})
        LiulianButton("Secondary", onPress = {}, variant = ButtonVariant.Secondary)
        LiulianButton("Ghost", onPress = {}, variant = ButtonVariant.Ghost)
        LiulianButton("Danger", onPress = {}, variant = ButtonVariant.Danger)
    }
    LiulianText("sizes", variant = LiulianTextVariant.MonoLabel, color = LiulianTokens.Colors.inkFaint)
    Row(horizontalArrangement = Arrangement.spacedBy(LiulianTokens.Spacing.s3)) {
        LiulianButton("Small", onPress = {}, size = ButtonSize.Sm)
        LiulianButton("Medium", onPress = {}, size = ButtonSize.Md)
        LiulianButton("Large", onPress = {}, size = ButtonSize.Lg)
    }
    LiulianText("states", variant = LiulianTextVariant.MonoLabel, color = LiulianTokens.Colors.inkFaint)
    Row(horizontalArrangement = Arrangement.spacedBy(LiulianTokens.Spacing.s3)) {
        LiulianButton("Loading", onPress = {}, loading = true)
        LiulianButton("Disabled", onPress = {}, disabled = true)
    }
}

@Composable
private fun SectionCard() {
    SectionTitle("LiulianCard")
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
    LiulianCard(interactive = true, onPress = {}) {
        LiulianText("Interactive", variant = LiulianTextVariant.Title)
        LiulianText("press = scale 0.99", variant = LiulianTextVariant.Body, color = LiulianTokens.Colors.inkMuted)
    }
    LiulianCard(selected = true) {
        LiulianText("Selected", variant = LiulianTextVariant.Title)
        LiulianText("border 2dp unibeRed", variant = LiulianTextVariant.Body, color = LiulianTokens.Colors.inkMuted)
    }
}

@Composable
private fun SectionTitle(title: String) {
    LiulianText(title, variant = LiulianTextVariant.Title, modifier = Modifier.padding(top = LiulianTokens.Spacing.s4))
}

@Preview(showBackground = true, backgroundColor = 0xFFFBFBFA, heightDp = 1200)
@Composable
private fun LiulianGalleryPreview() {
    LiulianGallery()
}

package io.liulian.ui

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.text.BasicText
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.TextUnit
import androidx.compose.ui.unit.em
import androidx.compose.ui.unit.sp
import io.liulian.tokens.LiulianTokens

/**
 * LiulianText — type renderer per ui-spec/Text.spec.md.
 *
 * Always use this for any visible text in LIULIAN. Maps `variant` to a fixed bundle of
 * (font, size, weight, lineHeight, letterSpacing, color).
 */
enum class LiulianTextVariant {
    Display, DisplayShort,
    Heading, Title, Subtitle,
    Body, BodyStrong,
    Caption, MonoLabel,
}

@Composable
fun LiulianText(
    text: String,
    modifier: Modifier = Modifier,
    variant: LiulianTextVariant = LiulianTextVariant.Body,
    color: androidx.compose.ui.graphics.Color = LiulianTokens.Colors.inkCharcoal,
    align: TextAlign = TextAlign.Start,
    maxLines: Int = Int.MAX_VALUE,
) {
    val displayFamily = LiulianFont.display()
    val bodyFamily = LiulianFont.body()
    val monoFamily = LiulianFont.mono()

    val style: TextStyle = when (variant) {
        LiulianTextVariant.Display -> TextStyle(
            fontFamily = displayFamily,
            fontSize = LiulianTokens.FontSize.xl6,
            fontWeight = FontWeight.Medium,
            lineHeight = (LiulianTokens.FontSize.xl6.value * 0.95f).sp,
            letterSpacing = (-0.04).em,
            color = color,
            textAlign = align,
        )
        LiulianTextVariant.DisplayShort -> TextStyle(
            fontFamily = displayFamily,
            fontSize = LiulianTokens.FontSize.xl5,
            fontWeight = FontWeight.Medium,
            lineHeight = (LiulianTokens.FontSize.xl5.value * 0.98f).sp,
            letterSpacing = (-0.035).em,
            color = color,
            textAlign = align,
        )
        LiulianTextVariant.Heading -> TextStyle(
            fontFamily = displayFamily,
            fontSize = LiulianTokens.FontSize.xl4,
            fontWeight = FontWeight.Medium,
            lineHeight = (LiulianTokens.FontSize.xl4.value * 1.05f).sp,
            letterSpacing = (-0.025).em,
            color = color,
            textAlign = align,
        )
        LiulianTextVariant.Title -> TextStyle(
            fontFamily = displayFamily,
            fontSize = LiulianTokens.FontSize.xl3,
            fontWeight = FontWeight.Medium,
            lineHeight = (LiulianTokens.FontSize.xl3.value * 1.12f).sp,
            letterSpacing = (-0.02).em,
            color = color,
            textAlign = align,
        )
        LiulianTextVariant.Subtitle -> TextStyle(
            fontFamily = bodyFamily,
            fontSize = LiulianTokens.FontSize.xl,
            fontWeight = FontWeight.Medium,
            lineHeight = (LiulianTokens.FontSize.xl.value * 1.35f).sp,
            letterSpacing = (-0.01).em,
            color = color,
            textAlign = align,
        )
        LiulianTextVariant.Body -> TextStyle(
            fontFamily = bodyFamily,
            fontSize = LiulianTokens.FontSize.md,
            fontWeight = FontWeight.Normal,
            lineHeight = (LiulianTokens.FontSize.md.value * 1.55f).sp,
            color = color,
            textAlign = align,
        )
        LiulianTextVariant.BodyStrong -> TextStyle(
            fontFamily = bodyFamily,
            fontSize = LiulianTokens.FontSize.md,
            fontWeight = FontWeight.Medium,
            lineHeight = (LiulianTokens.FontSize.md.value * 1.55f).sp,
            color = color,
            textAlign = align,
        )
        LiulianTextVariant.Caption -> TextStyle(
            fontFamily = bodyFamily,
            fontSize = LiulianTokens.FontSize.xs,
            fontWeight = FontWeight.Normal,
            lineHeight = (LiulianTokens.FontSize.xs.value * 1.45f).sp,
            color = color,
            textAlign = align,
        )
        LiulianTextVariant.MonoLabel -> TextStyle(
            fontFamily = monoFamily,
            fontSize = LiulianTokens.FontSize.xs,
            fontWeight = FontWeight.Medium,
            lineHeight = (LiulianTokens.FontSize.xs.value * 1.4f).sp,
            letterSpacing = 0.10.em,
            color = color,
            textAlign = align,
        )
    }

    val rendered: String =
        if (variant == LiulianTextVariant.MonoLabel) text.uppercase() else text

    BasicText(
        text = rendered,
        modifier = modifier,
        style = style,
        maxLines = maxLines,
        overflow = TextOverflow.Ellipsis,
    )
}

@Preview(showBackground = true, backgroundColor = 0xFFFBFBFA)
@Composable
private fun LiulianTextPreview() {
    Column(modifier = Modifier.padding(LiulianTokens.Spacing.s7).background(LiulianTokens.Colors.canvasWarm)) {
        LiulianText("LIULIAN", variant = LiulianTextVariant.Display)
        LiulianText("Forecast Canvas", variant = LiulianTextVariant.Heading)
        LiulianText("Aare-Bern station", variant = LiulianTextVariant.Title)
        LiulianText("Real-time water level monitoring", variant = LiulianTextVariant.Subtitle)
        LiulianText("Default paragraph text.", variant = LiulianTextVariant.Body)
        LiulianText("emphasis", variant = LiulianTextVariant.BodyStrong)
        LiulianText("meta · 12:34 UTC", variant = LiulianTextVariant.Caption, color = LiulianTokens.Colors.inkMuted)
        LiulianText("system status", variant = LiulianTextVariant.MonoLabel, color = LiulianTokens.Colors.inkFaint)
    }
}

package io.liulian.ui

import androidx.compose.animation.core.animateDpAsState
import androidx.compose.animation.core.tween
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.interaction.collectIsPressedAsState
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.offset
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.remember
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.alpha
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import io.liulian.tokens.LiulianTokens

enum class CardSize { Compact, Default, Spacious }

/**
 * LiulianCard — per ui-spec/Card.spec.md.
 *
 * Surface container with hairline border, three padding sizes, optional onPress (interactive).
 */
@Composable
fun LiulianCard(
    modifier: Modifier = Modifier,
    size: CardSize = CardSize.Default,
    interactive: Boolean = false,
    selected: Boolean = false,
    disabled: Boolean = false,
    onPress: (() -> Unit)? = null,
    header: (@Composable () -> Unit)? = null,
    footer: (@Composable () -> Unit)? = null,
    content: @Composable () -> Unit,
) {
    val interactionSource = remember { MutableInteractionSource() }
    val pressed by interactionSource.collectIsPressedAsState()

    val lift by animateDpAsState(
        targetValue = if (interactive && !pressed && !disabled) 0.dp else 0.dp,
        animationSpec =
            tween(
                durationMillis = LiulianTokens.Duration.medium,
                easing = LiulianTokens.Easing.easeOutQuart,
            ),
        label = "cardLift",
    )

    val padding =
        when (size) {
            CardSize.Compact -> LiulianTokens.Spacing.s4
            CardSize.Default -> LiulianTokens.Spacing.s6
            CardSize.Spacious -> LiulianTokens.Spacing.s7
        }
    val gap =
        when (size) {
            CardSize.Compact -> LiulianTokens.Spacing.s3
            CardSize.Default -> LiulianTokens.Spacing.s4
            CardSize.Spacious -> LiulianTokens.Spacing.s5
        }

    val borderColor: Color = if (selected) LiulianTokens.Colors.unibeRed else LiulianTokens.Colors.hairline
    val borderWidth = if (selected) 2.dp else 1.dp

    var rootModifier =
        modifier
            .fillMaxWidth()
            .alpha(if (disabled) LiulianTokens.Opacity.disabled else 1f)
            .offset(y = lift)
            .shadow(elevation = if (pressed) 0.dp else 0.dp, shape = RoundedCornerShape(LiulianTokens.Radius.md))
            .clip(RoundedCornerShape(LiulianTokens.Radius.md))
            .background(LiulianTokens.Colors.surfacePure)
            .border(borderWidth, borderColor, RoundedCornerShape(LiulianTokens.Radius.md))

    if (interactive && onPress != null) {
        rootModifier =
            rootModifier.clickable(
                interactionSource = interactionSource,
                indication = null,
                enabled = !disabled,
                onClick = onPress,
            )
    }
    rootModifier = rootModifier.padding(padding)

    Column(
        modifier = rootModifier,
        verticalArrangement = Arrangement.spacedBy(gap),
    ) {
        if (header != null) {
            header()
            Box(
                modifier =
                    Modifier
                        .fillMaxWidth()
                        .height(1.dp)
                        .background(LiulianTokens.Colors.hairline),
            )
        }
        content()
        if (footer != null) {
            Box(
                modifier =
                    Modifier
                        .fillMaxWidth()
                        .height(1.dp)
                        .background(LiulianTokens.Colors.hairline),
            )
            footer()
        }
    }
}

@Preview(showBackground = true, backgroundColor = 0xFFFBFBFA)
@Composable
private fun LiulianCardPreview() {
    Column(
        modifier =
            Modifier
                .padding(LiulianTokens.Spacing.s6)
                .background(LiulianTokens.Colors.canvasWarm),
        verticalArrangement = Arrangement.spacedBy(LiulianTokens.Spacing.s4),
    ) {
        LiulianCard(size = CardSize.Compact) {
            LiulianText("Compact", variant = LiulianTextVariant.Title)
            LiulianText("padding s4 (16)", variant = LiulianTextVariant.Body, color = LiulianTokens.Colors.inkMuted)
        }
        LiulianCard {
            LiulianText("Default", variant = LiulianTextVariant.Title)
            LiulianText("padding s6 (24)", variant = LiulianTextVariant.Body, color = LiulianTokens.Colors.inkMuted)
        }
        LiulianCard(size = CardSize.Spacious) {
            LiulianText("Spacious", variant = LiulianTextVariant.Title)
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
}

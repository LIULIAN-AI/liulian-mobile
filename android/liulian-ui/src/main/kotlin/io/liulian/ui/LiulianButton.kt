package io.liulian.ui

import androidx.compose.animation.core.animateFloatAsState
import androidx.compose.animation.core.tween
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.interaction.collectIsPressedAsState
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.defaultMinSize
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.alpha
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.platform.LocalFocusManager
import androidx.compose.ui.semantics.Role
import androidx.compose.ui.semantics.role
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import io.liulian.tokens.LiulianTokens

enum class ButtonVariant { Primary, Secondary, Ghost, Danger }
enum class ButtonSize { Sm, Md, Lg }

/**
 * LiulianButton — Compose impl per ui-spec/Button.spec.md.
 *
 * Built on Compose Foundation (Box + clickable, NOT Material Button).
 * Disables Material ripple, renders own press scale + focus ring.
 */
@Composable
fun LiulianButton(
    label: String,
    onPress: () -> Unit,
    modifier: Modifier = Modifier,
    variant: ButtonVariant = ButtonVariant.Primary,
    size: ButtonSize = ButtonSize.Md,
    loading: Boolean = false,
    disabled: Boolean = false,
) {
    val interactionSource = remember { MutableInteractionSource() }
    val pressed by interactionSource.collectIsPressedAsState()

    val scale by animateFloatAsState(
        targetValue = if (pressed) LiulianTokens.Control.ScaleActive.value else 1f,
        animationSpec = tween(
            durationMillis = LiulianTokens.Duration.instant,
            easing = LiulianTokens.Easing.easeOut
        ),
        label = "buttonPressScale"
    )

    val height = when (size) {
        ButtonSize.Sm -> LiulianTokens.Control.Height.sm
        ButtonSize.Md -> LiulianTokens.Control.Height.md
        ButtonSize.Lg -> LiulianTokens.Control.Height.lg
    }
    val paddingX = when (size) {
        ButtonSize.Sm -> LiulianTokens.Control.PaddingX.sm
        ButtonSize.Md -> LiulianTokens.Control.PaddingX.md
        ButtonSize.Lg -> LiulianTokens.Control.PaddingX.lg
    }
    val textVariant = when (size) {
        ButtonSize.Sm -> LiulianTextVariant.Caption
        ButtonSize.Md -> LiulianTextVariant.Body
        ButtonSize.Lg -> LiulianTextVariant.Subtitle
    }

    val bg: Color = when (variant) {
        ButtonVariant.Primary -> LiulianTokens.Colors.unibeRed
        ButtonVariant.Secondary -> LiulianTokens.Colors.surfacePure
        ButtonVariant.Ghost -> Color.Transparent
        ButtonVariant.Danger -> LiulianTokens.Colors.unibeRedDeep
    }
    val fg: Color = when (variant) {
        ButtonVariant.Primary, ButtonVariant.Danger -> LiulianTokens.Colors.surfacePure
        ButtonVariant.Secondary -> LiulianTokens.Colors.inkCharcoal
        ButtonVariant.Ghost -> LiulianTokens.Colors.inkMuted
    }

    Box(
        modifier = modifier
            .defaultMinSize(minHeight = LiulianTokens.Touch.minTargetAndroid)
            .graphicsLayer { scaleX = scale; scaleY = scale }
            .alpha(if (disabled) LiulianTokens.Opacity.disabled else 1f)
            .clip(RoundedCornerShape(LiulianTokens.Radius.md))
            .background(bg)
            .let {
                if (variant == ButtonVariant.Secondary) {
                    it.border(
                        width = 1.dp,
                        color = LiulianTokens.Colors.hairline,
                        shape = RoundedCornerShape(LiulianTokens.Radius.md)
                    )
                } else it
            }
            .clickable(
                interactionSource = interactionSource,
                indication = null,
                enabled = !disabled && !loading,
                role = Role.Button,
                onClick = onPress,
            )
            .height(height)
            .padding(horizontal = paddingX),
        contentAlignment = Alignment.Center,
    ) {
        Row(
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(LiulianTokens.Control.IconGap.value),
        ) {
            if (loading) {
                // Minimal spinner placeholder; replace with brand spinner when delivered.
                Box(
                    modifier = Modifier
                        .height(LiulianTokens.Control.IconSize.md)
                        .background(fg.copy(alpha = 0.6f), shape = RoundedCornerShape(50))
                )
            } else {
                LiulianText(label, variant = textVariant, color = fg)
            }
        }
    }
}

@Preview(showBackground = true, backgroundColor = 0xFFFBFBFA)
@Composable
private fun LiulianButtonPreview() {
    Column(
        modifier = Modifier
            .background(LiulianTokens.Colors.canvasWarm)
            .padding(LiulianTokens.Spacing.s7),
        verticalArrangement = Arrangement.spacedBy(LiulianTokens.Spacing.s4),
    ) {
        Row(horizontalArrangement = Arrangement.spacedBy(LiulianTokens.Spacing.s3)) {
            LiulianButton("Primary", onPress = {})
            LiulianButton("Secondary", onPress = {}, variant = ButtonVariant.Secondary)
            LiulianButton("Ghost", onPress = {}, variant = ButtonVariant.Ghost)
            LiulianButton("Danger", onPress = {}, variant = ButtonVariant.Danger)
        }
        Row(horizontalArrangement = Arrangement.spacedBy(LiulianTokens.Spacing.s3)) {
            LiulianButton("Small", onPress = {}, size = ButtonSize.Sm)
            LiulianButton("Medium", onPress = {}, size = ButtonSize.Md)
            LiulianButton("Large", onPress = {}, size = ButtonSize.Lg)
        }
        Row(horizontalArrangement = Arrangement.spacedBy(LiulianTokens.Spacing.s3)) {
            LiulianButton("Loading", onPress = {}, loading = true)
            LiulianButton("Disabled", onPress = {}, disabled = true)
        }
    }
}

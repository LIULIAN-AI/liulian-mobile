package io.liulian.ui

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.defaultMinSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.alpha
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import io.liulian.tokens.LiulianTokens

enum class ListItemVariant { Navigation, Content, Selectable, MultiSelectable }

/**
 * LiulianListItem — per ui-spec/ListItem.spec.md.
 *
 * Row with leading icon + primary/secondary labels + trailing affordance.
 * Min height 48 (Android+Harmony spec, exceeds iOS HIG 44 too).
 */
@Composable
fun LiulianListItem(
    primary: String,
    onPress: () -> Unit,
    modifier: Modifier = Modifier,
    variant: ListItemVariant = ListItemVariant.Content,
    secondary: String? = null,
    leadingIcon: String? = null,
    selected: Boolean = false,
    disabled: Boolean = false,
) {
    val source = remember { MutableInteractionSource() }
    val isInteractive = variant != ListItemVariant.Content

    val bg = when {
        selected && variant in listOf(ListItemVariant.Selectable, ListItemVariant.MultiSelectable) ->
            LiulianTokens.Colors.unibeRedTint
        else -> Color.Transparent
    }

    Row(
        modifier = modifier
            .fillMaxWidth()
            .defaultMinSize(minHeight = 48.dp)
            .background(bg)
            .alpha(if (disabled) LiulianTokens.Opacity.disabled else 1f)
            .let {
                if (isInteractive) {
                    it.clickable(
                        interactionSource = source,
                        indication = null,
                        enabled = !disabled,
                        onClick = onPress,
                    )
                } else it
            }
            .padding(
                horizontal = LiulianTokens.Spacing.s4,
                vertical = LiulianTokens.Spacing.s3,
            ),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(LiulianTokens.Spacing.s3),
    ) {
        if (leadingIcon != null) {
            // Glyph rendered as small text (no icon font yet — placeholder)
            Box(
                modifier = Modifier
                    .size(LiulianTokens.Control.IconSize.md)
                    .clip(RoundedCornerShape(LiulianTokens.Radius.sm)),
                contentAlignment = Alignment.Center,
            ) {
                LiulianText(
                    leadingIcon,
                    variant = LiulianTextVariant.MonoLabel,
                    color = LiulianTokens.Colors.inkMuted,
                )
            }
        }
        Column(
            modifier = Modifier.weight(1f, fill = true),
            verticalArrangement = Arrangement.spacedBy(LiulianTokens.Spacing.s1),
        ) {
            LiulianText(primary, variant = LiulianTextVariant.BodyStrong)
            if (secondary != null) {
                LiulianText(secondary, variant = LiulianTextVariant.Caption, color = LiulianTokens.Colors.inkMuted)
            }
        }
        // Trailing affordance
        when (variant) {
            ListItemVariant.Navigation -> {
                LiulianText("›", variant = LiulianTextVariant.Title, color = LiulianTokens.Colors.inkFaint)
            }
            ListItemVariant.Selectable -> {
                Box(
                    modifier = Modifier
                        .size(LiulianTokens.Control.IconSize.md)
                        .clip(CircleShape)
                        .border(
                            width = if (selected) 0.dp else 1.5.dp,
                            color = LiulianTokens.Colors.hairlineStrong,
                            shape = CircleShape,
                        )
                        .background(if (selected) LiulianTokens.Colors.unibeRed else Color.Transparent),
                    contentAlignment = Alignment.Center,
                ) {
                    if (selected) {
                        LiulianText("✓", variant = LiulianTextVariant.Caption, color = LiulianTokens.Colors.surfacePure)
                    }
                }
            }
            ListItemVariant.MultiSelectable -> {
                Box(
                    modifier = Modifier
                        .size(LiulianTokens.Control.IconSize.md)
                        .clip(RoundedCornerShape(LiulianTokens.Radius.sm))
                        .border(
                            width = if (selected) 0.dp else 1.5.dp,
                            color = LiulianTokens.Colors.hairlineStrong,
                            shape = RoundedCornerShape(LiulianTokens.Radius.sm),
                        )
                        .background(if (selected) LiulianTokens.Colors.unibeRed else Color.Transparent),
                    contentAlignment = Alignment.Center,
                ) {
                    if (selected) {
                        LiulianText("✓", variant = LiulianTextVariant.Caption, color = LiulianTokens.Colors.surfacePure)
                    }
                }
            }
            ListItemVariant.Content -> Unit  // no trailing
        }
    }
}

@Preview(showBackground = true, backgroundColor = 0xFFFBFBFA)
@Composable
private fun LiulianListItemPreview() {
    Column(modifier = Modifier.padding(LiulianTokens.Spacing.s4)) {
        LiulianListItem(
            primary = "aare-bern",
            secondary = "142 cm · forecast +6",
            onPress = {},
            variant = ListItemVariant.Navigation,
        )
        LiulianListItem(
            primary = "rhein-rheinfelden",
            secondary = "78 cm · stable",
            onPress = {},
            variant = ListItemVariant.Selectable,
            selected = true,
        )
        LiulianListItem(
            primary = "ticino-bellinzona",
            secondary = "210 cm · -3 / 24h",
            onPress = {},
            variant = ListItemVariant.MultiSelectable,
            selected = false,
        )
        LiulianListItem(
            primary = "limmat-baden",
            secondary = "static, no chevron",
            onPress = {},
            variant = ListItemVariant.Content,
        )
        LiulianListItem(
            primary = "disabled-item",
            secondary = "no interaction",
            onPress = {},
            variant = ListItemVariant.Navigation,
            disabled = true,
        )
    }
}

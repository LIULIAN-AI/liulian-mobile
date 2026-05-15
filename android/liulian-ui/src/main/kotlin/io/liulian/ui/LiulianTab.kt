package io.liulian.ui

import androidx.compose.animation.core.animateDpAsState
import androidx.compose.animation.core.tween
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.offset
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.alpha
import androidx.compose.ui.layout.onGloballyPositioned
import androidx.compose.ui.layout.positionInParent
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import io.liulian.tokens.LiulianTokens

data class LiulianTabItem(
    val id: String,
    val label: String,
    val disabled: Boolean = false,
)

enum class TabVariant { Default, Compact }

/**
 * LiulianTab — segmented horizontal nav per ui-spec/Tab.spec.md.
 *
 * Active indicator is a single bar that animates X position between tabs.
 * That's the LIULIAN signature — NOT a Material per-tab indicator with fade.
 */
@Composable
fun LiulianTab(
    items: List<LiulianTabItem>,
    activeId: String,
    onChange: (String) -> Unit,
    modifier: Modifier = Modifier,
    variant: TabVariant = TabVariant.Default,
) {
    val height = when (variant) {
        TabVariant.Default -> LiulianTokens.Control.Height.md
        TabVariant.Compact -> LiulianTokens.Control.Height.sm
    }
    val itemPaddingX = LiulianTokens.Spacing.s4  // 16
    val density = LocalDensity.current

    // Measured tab positions in raw pixels (Int). Converted to Dp when consumed.
    val positions = remember { mutableStateOf(mapOf<String, Pair<Int, Int>>()) }

    val activePos = positions.value[activeId]
    val indicatorX by animateDpAsState(
        targetValue = with(density) { (activePos?.first ?: 0).toDp() },
        animationSpec = tween(
            durationMillis = LiulianTokens.Duration.fast,
            easing = LiulianTokens.Easing.easeOutQuart,
        ),
        label = "tabIndicatorX",
    )
    val indicatorWidth by animateDpAsState(
        targetValue = with(density) { (activePos?.second ?: 0).toDp() },
        animationSpec = tween(
            durationMillis = LiulianTokens.Duration.fast,
            easing = LiulianTokens.Easing.easeOutQuart,
        ),
        label = "tabIndicatorWidth",
    )

    Box(
        modifier = modifier
            .fillMaxWidth()
            .height(height)
            .background(LiulianTokens.Colors.canvasWarm)
            .border(width = 0.dp, color = LiulianTokens.Colors.hairline),
    ) {
        Row(
            modifier = Modifier.fillMaxWidth(),
            verticalAlignment = Alignment.CenterVertically,
        ) {
            items.forEach { item ->
                val isActive = item.id == activeId
                val source = remember { MutableInteractionSource() }
                Box(
                    modifier = Modifier
                        .height(height)
                        .alpha(if (item.disabled) LiulianTokens.Opacity.disabled else 1f)
                        .clickable(
                            interactionSource = source,
                            indication = null,
                            enabled = !item.disabled,
                            onClick = { onChange(item.id) },
                        )
                        .padding(horizontal = itemPaddingX)
                        .onGloballyPositioned { coords ->
                            val xPx = coords.positionInParent().x.toInt()
                            val wPx = coords.size.width
                            positions.value = positions.value + (item.id to (xPx to wPx))
                        },
                    contentAlignment = Alignment.Center,
                ) {
                    LiulianText(
                        text = item.label,
                        variant = LiulianTextVariant.MonoLabel,
                        color = if (isActive) LiulianTokens.Colors.inkCharcoal else LiulianTokens.Colors.inkMuted,
                    )
                }
            }
        }

        // Active indicator + hairline bottom border, drawn in the same Box
        Box(
            modifier = Modifier
                .fillMaxWidth()
                .height(1.dp)
                .offset(y = (height.value - 1).dp)
                .background(LiulianTokens.Colors.hairline),
        )
        if (activePos != null) {
            Box(
                modifier = Modifier
                    .offset(x = indicatorX, y = (height.value - 2).dp)
                    .height(2.dp)
                    .width(indicatorWidth)
                    .background(LiulianTokens.Colors.unibeRed),
            )
        }
    }
}

@Preview(showBackground = true, backgroundColor = 0xFFFBFBFA)
@Composable
private fun LiulianTabPreview() {
    var active by remember { mutableStateOf("forecast") }
    LiulianTab(
        items = listOf(
            LiulianTabItem("landing", "LANDING"),
            LiulianTabItem("forecast", "FORECAST"),
            LiulianTabItem("studio", "STUDIO"),
        ),
        activeId = active,
        onChange = { active = it },
    )
}

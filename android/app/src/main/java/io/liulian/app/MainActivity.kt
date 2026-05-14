package io.liulian.app

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.statusBarsPadding
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import io.liulian.tokens.LiulianTokens
import io.liulian.ui.ButtonVariant
import io.liulian.ui.ButtonSize
import io.liulian.ui.LiulianButton

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent { App() }
    }
}

@Composable
private fun App() {
    var tab by remember { mutableStateOf(Tab.Home) }

    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(LiulianTokens.Colors.canvasWarm)
            .statusBarsPadding(),
    ) {
        Column(modifier = Modifier.fillMaxSize()) {
            Box(modifier = Modifier.fillMaxWidth().weight(1f)) {
                when (tab) {
                    Tab.Home -> HomeScreen()
                    Tab.Gallery -> GalleryScreen()
                }
            }
            BottomTabBar(active = tab, onSelect = { tab = it })
        }
    }
}

private enum class Tab { Home, Gallery }

@Composable
private fun BottomTabBar(active: Tab, onSelect: (Tab) -> Unit) {
    Box(
        modifier = Modifier
            .fillMaxWidth()
            .height(64.dp)
            .background(LiulianTokens.Colors.surfacePure)
            .border(width = 1.dp, color = LiulianTokens.Colors.hairline),
        contentAlignment = Alignment.Center,
    ) {
        Row(
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.spacedBy(LiulianTokens.Spacing.s3),
        ) {
            LiulianButton(
                "Home",
                onPress = { onSelect(Tab.Home) },
                variant = if (active == Tab.Home) ButtonVariant.Primary else ButtonVariant.Ghost,
                size = ButtonSize.Sm,
            )
            LiulianButton(
                "Gallery",
                onPress = { onSelect(Tab.Gallery) },
                variant = if (active == Tab.Gallery) ButtonVariant.Primary else ButtonVariant.Ghost,
                size = ButtonSize.Sm,
            )
        }
    }
}

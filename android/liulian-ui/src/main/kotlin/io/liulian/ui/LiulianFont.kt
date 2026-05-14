package io.liulian.ui

import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
import androidx.compose.ui.text.font.Font
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight

/**
 * Loads Fraunces / Switzer / JetBrains Mono font families from res/font/.
 *
 * Per ui-spec/Text.spec.md, this is the ONLY way text should be styled in LiulianUI.
 *
 * IMPORTANT: This relies on font files being present at:
 *   res/font/fraunces.ttf
 *   res/font/switzer_regular.{ttf,otf}
 *   res/font/switzer_medium.{ttf,otf}
 *   res/font/jetbrains_mono_regular.ttf
 *   res/font/jetbrains_mono_medium.ttf
 *
 * Run `bash shared/scripts/fetch-fonts.sh` to install.
 */
object LiulianFont {
    @Composable
    fun display(): FontFamily =
        remember {
            FontFamily(Font(R.font.fraunces, FontWeight.Medium))
        }

    @Composable
    fun body(): FontFamily =
        remember {
            FontFamily(
                Font(R.font.switzer_regular, FontWeight.Normal),
                Font(R.font.switzer_medium, FontWeight.Medium),
            )
        }

    @Composable
    fun mono(): FontFamily =
        remember {
            FontFamily(
                Font(R.font.jetbrains_mono_regular, FontWeight.Normal),
                Font(R.font.jetbrains_mono_medium, FontWeight.Medium),
            )
        }
}

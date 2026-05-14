package io.liulian.app

import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import io.liulian.ui.LiulianGallery

/** Thin wrapper to expose LiulianUI's gallery in the app tab bar. */
@Composable
fun GalleryScreen(modifier: Modifier = Modifier) {
    LiulianGallery(modifier = modifier)
}

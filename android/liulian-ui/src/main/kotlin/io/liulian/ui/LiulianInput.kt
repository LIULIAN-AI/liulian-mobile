package io.liulian.ui

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.BasicTextField
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.focus.onFocusChanged
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.text.input.PasswordVisualTransformation
import androidx.compose.ui.text.input.VisualTransformation
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.foundation.text.KeyboardOptions
import io.liulian.tokens.LiulianTokens

enum class InputVariant { Text, Password, Search, Number, Textarea }
enum class InputSize { Sm, Md }

/**
 * LiulianInput — Compose impl per ui-spec/Input.spec.md.
 *
 * BasicTextField wrapped in own bordered Box. No Material TextField — avoids ripple
 * + lets us control border color on focus/error precisely.
 */
@Composable
fun LiulianInput(
    value: String,
    onChange: (String) -> Unit,
    modifier: Modifier = Modifier,
    variant: InputVariant = InputVariant.Text,
    size: InputSize = InputSize.Md,
    label: String? = null,
    placeholder: String? = null,
    helpText: String? = null,
    errorText: String? = null,
    disabled: Boolean = false,
    readonly: Boolean = false,
) {
    var focused by remember { mutableStateOf(false) }
    val hasError = errorText != null

    val borderColor = when {
        hasError -> LiulianTokens.Colors.unibeRedText
        focused -> LiulianTokens.Colors.unibeRed
        else -> LiulianTokens.Colors.hairline
    }
    val bg = if (disabled || readonly) LiulianTokens.Colors.surfaceShade else LiulianTokens.Colors.surfacePure

    val height = if (variant == InputVariant.Textarea) 80.dp else when (size) {
        InputSize.Sm -> LiulianTokens.Control.Height.sm
        InputSize.Md -> LiulianTokens.Control.Height.md
    }

    Column(
        modifier = modifier,
        verticalArrangement = Arrangement.spacedBy(LiulianTokens.Spacing.s2),
    ) {
        if (label != null) {
            LiulianText(label, variant = LiulianTextVariant.BodyStrong, color = LiulianTokens.Colors.inkCharcoal)
        }
        Box(
            modifier = Modifier
                .fillMaxWidth()
                .height(height)
                .clip(RoundedCornerShape(LiulianTokens.Radius.sm))
                .background(bg)
                .border(1.dp, borderColor, RoundedCornerShape(LiulianTokens.Radius.sm))
                .padding(horizontal = LiulianTokens.Spacing.s3),
            contentAlignment = if (variant == InputVariant.Textarea) Alignment.TopStart else Alignment.CenterStart,
        ) {
            val textStyle = TextStyle(
                fontFamily = LiulianFont.body(),
                fontSize = LiulianTokens.FontSize.md,
                color = LiulianTokens.Colors.inkCharcoal,
            )
            if (value.isEmpty() && placeholder != null) {
                LiulianText(placeholder, variant = LiulianTextVariant.Body, color = LiulianTokens.Colors.inkFaint)
            }
            BasicTextField(
                value = value,
                onValueChange = { if (!disabled && !readonly) onChange(it) },
                modifier = Modifier
                    .fillMaxWidth()
                    .onFocusChanged { focused = it.isFocused },
                enabled = !disabled,
                readOnly = readonly,
                singleLine = variant != InputVariant.Textarea,
                textStyle = textStyle,
                cursorBrush = androidx.compose.ui.graphics.SolidColor(LiulianTokens.Colors.unibeRed),
                visualTransformation = if (variant == InputVariant.Password) PasswordVisualTransformation() else VisualTransformation.None,
                keyboardOptions = KeyboardOptions(
                    keyboardType = when (variant) {
                        InputVariant.Number -> KeyboardType.Number
                        InputVariant.Password -> KeyboardType.Password
                        InputVariant.Search -> KeyboardType.Text
                        else -> KeyboardType.Text
                    },
                    imeAction = if (variant == InputVariant.Search) ImeAction.Search else ImeAction.Default,
                ),
            )
        }
        if (hasError) {
            LiulianText(errorText!!, variant = LiulianTextVariant.Caption, color = LiulianTokens.Colors.unibeRedText)
        } else if (helpText != null) {
            LiulianText(helpText, variant = LiulianTextVariant.Caption, color = LiulianTokens.Colors.inkMuted)
        }
    }
}

@Preview(showBackground = true, backgroundColor = 0xFFFBFBFA)
@Composable
private fun LiulianInputPreview() {
    Column(
        modifier = Modifier.padding(LiulianTokens.Spacing.s6),
        verticalArrangement = Arrangement.spacedBy(LiulianTokens.Spacing.s4),
    ) {
        LiulianInput(value = "", onChange = {}, label = "Station name", placeholder = "e.g. aare-bern")
        LiulianInput(value = "secret", onChange = {}, variant = InputVariant.Password, label = "Token", helpText = "Treat as a password")
        LiulianInput(value = "abc", onChange = {}, label = "Validated", errorText = "Must start with a letter")
        LiulianInput(value = "read-only", onChange = {}, label = "Readonly", readonly = true)
        LiulianInput(value = "disabled", onChange = {}, label = "Disabled", disabled = true)
        LiulianInput(value = "", onChange = {}, variant = InputVariant.Textarea, label = "Notes", placeholder = "Longer text…")
    }
}

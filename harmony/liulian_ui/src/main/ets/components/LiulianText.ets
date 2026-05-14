// LiulianText — ArkUI impl of Text component per ui-spec/Text.spec.md.

import { Colors, Fonts, FontSize } from './tokens';

export enum TextVariant {
  Display = 'display',
  DisplayShort = 'displayShort',
  Heading = 'heading',
  Title = 'title',
  Subtitle = 'subtitle',
  Body = 'body',
  BodyStrong = 'bodyStrong',
  Caption = 'caption',
  MonoLabel = 'monoLabel',
}

interface TextStyleBundle {
  family: string;
  size: number;
  weight: number;
  lineHeight: number;     // multiplier
  letterSpacing: number;  // in fs units (em-like)
  uppercase: boolean;
}

const STYLES: Record<TextVariant, TextStyleBundle> = {
  [TextVariant.Display]:      { family: Fonts.display, size: FontSize.xl6, weight: 500, lineHeight: 0.95, letterSpacing: -0.04, uppercase: false },
  [TextVariant.DisplayShort]: { family: Fonts.display, size: FontSize.xl5, weight: 500, lineHeight: 0.98, letterSpacing: -0.035, uppercase: false },
  [TextVariant.Heading]:      { family: Fonts.display, size: FontSize.xl4, weight: 500, lineHeight: 1.05, letterSpacing: -0.025, uppercase: false },
  [TextVariant.Title]:        { family: Fonts.display, size: FontSize.xl3, weight: 500, lineHeight: 1.12, letterSpacing: -0.02, uppercase: false },
  [TextVariant.Subtitle]:     { family: Fonts.body,    size: FontSize.xl,  weight: 500, lineHeight: 1.35, letterSpacing: -0.01, uppercase: false },
  [TextVariant.Body]:         { family: Fonts.body,    size: FontSize.md,  weight: 400, lineHeight: 1.55, letterSpacing: 0,    uppercase: false },
  [TextVariant.BodyStrong]:   { family: Fonts.body,    size: FontSize.md,  weight: 500, lineHeight: 1.55, letterSpacing: 0,    uppercase: false },
  [TextVariant.Caption]:      { family: Fonts.body,    size: FontSize.xs,  weight: 400, lineHeight: 1.45, letterSpacing: 0,    uppercase: false },
  [TextVariant.MonoLabel]:    { family: Fonts.mono,    size: FontSize.xs,  weight: 500, lineHeight: 1.40, letterSpacing: 0.10, uppercase: true },
};

@Component
export struct LiulianText {
  @Prop text: string = '';
  @Prop variant: TextVariant = TextVariant.Body;
  @Prop color: string = Colors.inkCharcoal;

  build() {
    Text(STYLES[this.variant].uppercase ? this.text.toUpperCase() : this.text)
      .fontFamily(STYLES[this.variant].family)
      .fontSize(STYLES[this.variant].size)
      .fontWeight(STYLES[this.variant].weight)
      .fontColor(this.color)
      .lineHeight(STYLES[this.variant].size * STYLES[this.variant].lineHeight)
      .letterSpacing(STYLES[this.variant].size * STYLES[this.variant].letterSpacing);
  }
}

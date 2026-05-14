// LiulianGallery — VR baseline page. Renders all component variants × states.

import { Colors, Spacing } from './tokens';
import { LiulianText, TextVariant } from './LiulianText';
import { LiulianButton, ButtonVariant, ButtonSize } from './LiulianButton';
import { LiulianCard, CardSize } from './LiulianCard';

@Component
export struct LiulianGallery {

  @Builder
  buildButtonContent() {
    Column({ space: Spacing.s3 }) {
      Row({ space: Spacing.s3 }) {
        LiulianButton({ label: 'Primary' });
        LiulianButton({ label: 'Secondary', variant: ButtonVariant.Secondary });
        LiulianButton({ label: 'Ghost', variant: ButtonVariant.Ghost });
        LiulianButton({ label: 'Danger', variant: ButtonVariant.Danger });
      }
      Row({ space: Spacing.s3 }) {
        LiulianButton({ label: 'Small', size: ButtonSize.Sm });
        LiulianButton({ label: 'Medium', size: ButtonSize.Md });
        LiulianButton({ label: 'Large', size: ButtonSize.Lg });
      }
      Row({ space: Spacing.s3 }) {
        LiulianButton({ label: 'Loading', loading: true });
        LiulianButton({ label: 'Disabled', disabled: true });
      }
    }
    .alignItems(HorizontalAlign.Start);
  }

  @Builder
  buildCardCompactContent() {
    LiulianText({ text: 'Compact card', variant: TextVariant.Title });
    LiulianText({ text: 'padding s4 (16)', variant: TextVariant.Body, color: Colors.inkMuted });
  }

  @Builder
  buildCardDefaultContent() {
    LiulianText({ text: 'Default card', variant: TextVariant.Title });
    LiulianText({ text: 'padding s6 (24)', variant: TextVariant.Body, color: Colors.inkMuted });
  }

  @Builder
  buildCardSpaciousContent() {
    LiulianText({ text: 'Spacious card', variant: TextVariant.Title });
    LiulianText({ text: 'padding s7 (32)', variant: TextVariant.Body, color: Colors.inkMuted });
  }

  @Builder
  buildCardInteractiveContent() {
    LiulianText({ text: 'Interactive', variant: TextVariant.Title });
    LiulianText({ text: 'press = scale 0.99', variant: TextVariant.Body, color: Colors.inkMuted });
  }

  @Builder
  buildCardSelectedContent() {
    LiulianText({ text: 'Selected', variant: TextVariant.Title });
    LiulianText({ text: 'border 2 unibeRed', variant: TextVariant.Body, color: Colors.inkMuted });
  }

  build() {
    Scroll() {
      Column({ space: Spacing.s8 }) {
        // Header
        Column({ space: Spacing.s2 }) {
          LiulianText({ text: 'LIULIAN · HarmonyOS', variant: TextVariant.MonoLabel, color: Colors.inkFaint });
          LiulianText({ text: 'Component Gallery', variant: TextVariant.Heading });
          LiulianText({ text: 'Visual regression baseline. All variants × all states.', variant: TextVariant.Body, color: Colors.inkMuted });
        }.alignItems(HorizontalAlign.Start);

        // Text
        Column({ space: Spacing.s3 }) {
          LiulianText({ text: 'LiulianText', variant: TextVariant.Title });
          LiulianText({ text: 'display 96', variant: TextVariant.Display });
          LiulianText({ text: 'displayShort 56', variant: TextVariant.DisplayShort });
          LiulianText({ text: 'heading 38', variant: TextVariant.Heading });
          LiulianText({ text: 'title 28', variant: TextVariant.Title });
          LiulianText({ text: 'subtitle 18', variant: TextVariant.Subtitle });
          LiulianText({ text: 'body 13.5', variant: TextVariant.Body });
          LiulianText({ text: 'bodyStrong 13.5/500', variant: TextVariant.BodyStrong });
          LiulianText({ text: 'caption 10.5', variant: TextVariant.Caption, color: Colors.inkMuted });
          LiulianText({ text: 'monoLabel 10.5', variant: TextVariant.MonoLabel, color: Colors.inkFaint });
        }.alignItems(HorizontalAlign.Start);

        // Button
        Column({ space: Spacing.s3 }) {
          LiulianText({ text: 'LiulianButton', variant: TextVariant.Title });
          this.buildButtonContent();
        }.alignItems(HorizontalAlign.Start);

        // Card
        Column({ space: Spacing.s3 }) {
          LiulianText({ text: 'LiulianCard', variant: TextVariant.Title });
          LiulianCard({ size: CardSize.Compact, content: () => this.buildCardCompactContent() });
          LiulianCard({ size: CardSize.Default, content: () => this.buildCardDefaultContent() });
          LiulianCard({ size: CardSize.Spacious, content: () => this.buildCardSpaciousContent() });
          LiulianCard({ size: CardSize.Default, interactive: true, content: () => this.buildCardInteractiveContent() });
          LiulianCard({ size: CardSize.Default, selected: true, content: () => this.buildCardSelectedContent() });
        }.alignItems(HorizontalAlign.Start);
      }
      .padding(Spacing.s6)
      .alignItems(HorizontalAlign.Start);
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Colors.canvasWarm);
  }
}

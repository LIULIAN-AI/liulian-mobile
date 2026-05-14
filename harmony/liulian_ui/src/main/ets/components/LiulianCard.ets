// LiulianCard — ArkUI impl per ui-spec/Card.spec.md.

import { Colors, Spacing, Radius, Opacity, Duration } from './tokens';
import { LiulianCurves } from './LiulianFont';

export enum CardSize { Compact = 'compact', Default = 'default', Spacious = 'spacious' }

@Component
export struct LiulianCard {
  @Prop size: CardSize = CardSize.Default;
  @Prop interactive: boolean = false;
  @Prop selected: boolean = false;
  @Prop disabled: boolean = false;
  onPress: () => void = () => {};
  @BuilderParam content: () => void = () => {};
  @BuilderParam header: () => void = () => {};
  @BuilderParam footer: () => void = () => {};
  @Prop hasHeader: boolean = false;
  @Prop hasFooter: boolean = false;

  @State private pressed: boolean = false;

  private padding(): number {
    if (this.size === CardSize.Compact) return Spacing.s4;
    if (this.size === CardSize.Spacious) return Spacing.s7;
    return Spacing.s6;
  }

  private gap(): number {
    if (this.size === CardSize.Compact) return Spacing.s3;
    if (this.size === CardSize.Spacious) return Spacing.s5;
    return Spacing.s4;
  }

  private borderColor(): string {
    if (this.selected) return Colors.unibeRed;
    return Colors.hairline;
  }

  private borderWidth(): number {
    return this.selected ? 2 : 1;
  }

  build() {
    Column({ space: this.gap() }) {
      if (this.hasHeader) {
        this.header();
        Divider().color(Colors.hairline).strokeWidth(1);
      }
      this.content();
      if (this.hasFooter) {
        Divider().color(Colors.hairline).strokeWidth(1);
        this.footer();
      }
    }
    .width('100%')
    .padding(this.padding())
    .backgroundColor(Colors.surfacePure)
    .borderRadius(Radius.md)
    .border({ width: this.borderWidth(), color: this.borderColor() })
    .opacity(this.disabled ? Opacity.disabled : 1.0)
    .scale({ x: this.pressed && this.interactive ? 0.99 : 1.0, y: this.pressed && this.interactive ? 0.99 : 1.0 })
    .animation({ duration: Duration.medium, curve: LiulianCurves.easeOutQuart() })
    .onTouch((event) => {
      if (!this.interactive || this.disabled) return;
      if (event.type === 1) this.pressed = true;
      else this.pressed = false;
    })
    .onClick(() => {
      if (this.interactive && !this.disabled) this.onPress();
    });
  }
}

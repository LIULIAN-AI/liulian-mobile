// LiulianButton — ArkUI impl per ui-spec/Button.spec.md.

import { Colors, Control, Radius, Opacity, Touch, Duration } from './tokens';
import { LiulianText, TextVariant } from './LiulianText';
import { LiulianCurves } from './LiulianFont';

export enum ButtonVariant { Primary = 'primary', Secondary = 'secondary', Ghost = 'ghost', Danger = 'danger' }
export enum ButtonSize { Sm = 'sm', Md = 'md', Lg = 'lg' }

@Component
export struct LiulianButton {
  @Prop label: string = '';
  @Prop variant: ButtonVariant = ButtonVariant.Primary;
  @Prop size: ButtonSize = ButtonSize.Md;
  @Prop loading: boolean = false;
  @Prop disabled: boolean = false;
  onPress: () => void = () => {};

  @State private pressed: boolean = false;

  private height(): number {
    if (this.size === ButtonSize.Sm) return Control.Height.sm;
    if (this.size === ButtonSize.Lg) return Control.Height.lg;
    return Control.Height.md;
  }

  private paddingX(): number {
    if (this.size === ButtonSize.Sm) return Control.PaddingX.sm;
    if (this.size === ButtonSize.Lg) return Control.PaddingX.lg;
    return Control.PaddingX.md;
  }

  private textVariant(): TextVariant {
    if (this.size === ButtonSize.Sm) return TextVariant.Caption;
    if (this.size === ButtonSize.Lg) return TextVariant.Subtitle;
    return TextVariant.Body;
  }

  private bg(): string {
    if (this.variant === ButtonVariant.Primary) return Colors.unibeRed;
    if (this.variant === ButtonVariant.Secondary) return Colors.surfacePure;
    if (this.variant === ButtonVariant.Ghost) return '#00000000'; // transparent
    return Colors.unibeRedDeep; // danger
  }

  private fg(): string {
    if (this.variant === ButtonVariant.Primary || this.variant === ButtonVariant.Danger) return Colors.surfacePure;
    if (this.variant === ButtonVariant.Secondary) return Colors.inkCharcoal;
    return Colors.inkMuted; // ghost
  }

  private hasBorder(): boolean {
    return this.variant === ButtonVariant.Secondary;
  }

  build() {
    Stack() {
      if (this.loading) {
        // Placeholder spinner; replace with brand spinner component once delivered.
        Text('…')
          .fontColor(this.fg())
          .fontSize(this.height() / 2);
      } else {
        LiulianText({ text: this.label, variant: this.textVariant(), color: this.fg() });
      }
    }
    .height(this.height())
    .padding({ left: this.paddingX(), right: this.paddingX() })
    .constraintSize({ minWidth: Touch.minTargetHarmony, minHeight: Touch.minTargetHarmony })
    .backgroundColor(this.bg())
    .borderRadius(Radius.md)
    .border(this.hasBorder() ? { width: 1, color: Colors.hairline } : { width: 0 })
    .opacity(this.disabled ? Opacity.disabled : 1.0)
    .scale({ x: this.pressed ? Control.ScaleActive.value : 1.0, y: this.pressed ? Control.ScaleActive.value : 1.0 })
    .animation({ duration: Duration.instant, curve: LiulianCurves.easeOut() })
    .onTouch((event) => {
      if (this.disabled || this.loading) return;
      // event.type: 1=down, 2=up, 3=cancel (per ArkUI TouchType)
      if (event.type === 1) this.pressed = true;
      else this.pressed = false;
    })
    .onClick(() => {
      if (!this.disabled && !this.loading) this.onPress();
    });
  }
}

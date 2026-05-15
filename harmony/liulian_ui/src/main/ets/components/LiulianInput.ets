// LiulianInput — ArkUI impl per ui-spec/Input.spec.md.

import { Colors, Spacing, Radius, Opacity, FontSize, Control, Fonts } from './tokens';
import { LiulianText, TextVariant } from './LiulianText';

export enum InputVariant { Text = 'text', Password = 'password', Search = 'search', Number = 'number', Textarea = 'textarea' }
export enum InputSize { Sm = 'sm', Md = 'md' }

@Component
export struct LiulianInput {
  @Prop value: string = '';
  @Prop variant: InputVariant = InputVariant.Text;
  @Prop size: InputSize = InputSize.Md;
  @Prop label: string = '';
  @Prop placeholder: string = '';
  @Prop helpText: string = '';
  @Prop errorText: string = '';
  @Prop disabled: boolean = false;
  @Prop readonly: boolean = false;
  onChange: (s: string) => void = () => {};

  @State private focused: boolean = false;

  private height(): number {
    if (this.variant === InputVariant.Textarea) return 80;
    return this.size === InputSize.Sm ? Control.Height.sm : Control.Height.md;
  }

  private borderColor(): string {
    if (this.errorText !== '') return Colors.unibeRedText;
    if (this.focused) return Colors.unibeRed;
    return Colors.hairline;
  }

  private bg(): string {
    return (this.disabled || this.readonly) ? Colors.surfaceShade : Colors.surfacePure;
  }

  build() {
    Column({ space: Spacing.s2 }) {
      if (this.label !== '') {
        LiulianText({ text: this.label, variant: TextVariant.BodyStrong, color: Colors.inkCharcoal });
      }

      if (this.variant === InputVariant.Textarea) {
        TextArea({ placeholder: this.placeholder, text: this.value })
          .fontFamily(Fonts.body)
          .fontSize(FontSize.md)
          .fontColor(Colors.inkCharcoal)
          .placeholderColor(Colors.inkFaint)
          .height(this.height())
          .width('100%')
          .padding({ left: Spacing.s3, right: Spacing.s3, top: Spacing.s2, bottom: Spacing.s2 })
          .backgroundColor(this.bg())
          .borderRadius(Radius.sm)
          .border({ width: 1, color: this.borderColor() })
          .opacity(this.disabled ? Opacity.disabled : 1.0)
          .enabled(!this.disabled && !this.readonly)
          .onChange((s: string) => { if (!this.disabled && !this.readonly) this.onChange(s); })
          .onFocus(() => { this.focused = true; })
          .onBlur(() => { this.focused = false; });
      } else {
        TextInput({ placeholder: this.placeholder, text: this.value })
          .type(this.variant === InputVariant.Password ? InputType.Password :
                this.variant === InputVariant.Number ? InputType.Number :
                this.variant === InputVariant.Search ? InputType.Normal : InputType.Normal)
          .fontFamily(Fonts.body)
          .fontSize(FontSize.md)
          .fontColor(Colors.inkCharcoal)
          .placeholderColor(Colors.inkFaint)
          .caretColor(Colors.unibeRed)
          .height(this.height())
          .width('100%')
          .padding({ left: Spacing.s3, right: Spacing.s3 })
          .backgroundColor(this.bg())
          .borderRadius(Radius.sm)
          .border({ width: 1, color: this.borderColor() })
          .opacity(this.disabled ? Opacity.disabled : 1.0)
          .enabled(!this.disabled && !this.readonly)
          .onChange((s: string) => { if (!this.disabled && !this.readonly) this.onChange(s); })
          .onFocus(() => { this.focused = true; })
          .onBlur(() => { this.focused = false; });
      }

      if (this.errorText !== '') {
        LiulianText({ text: this.errorText, variant: TextVariant.Caption, color: Colors.unibeRedText });
      } else if (this.helpText !== '') {
        LiulianText({ text: this.helpText, variant: TextVariant.Caption, color: Colors.inkMuted });
      }
    }
    .alignItems(HorizontalAlign.Start);
  }
}

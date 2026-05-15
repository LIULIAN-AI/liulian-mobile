// LiulianListItem — ArkUI impl per ui-spec/ListItem.spec.md.

import { Colors, Spacing, Radius, Opacity, Control } from './tokens';
import { LiulianText, TextVariant } from './LiulianText';

export enum ListItemVariant { Navigation = 'navigation', Content = 'content', Selectable = 'selectable', MultiSelectable = 'multiSelectable' }

@Component
export struct LiulianListItem {
  @Prop primary: string = '';
  @Prop secondary: string = '';
  @Prop leadingIcon: string = '';
  @Prop variant: ListItemVariant = ListItemVariant.Content;
  @Prop selected: boolean = false;
  @Prop disabled: boolean = false;
  onPress: () => void = () => {};

  private bg(): string {
    if (this.selected && (this.variant === ListItemVariant.Selectable || this.variant === ListItemVariant.MultiSelectable)) {
      return Colors.unibeRedTint;
    }
    return '#00000000'; // transparent
  }

  @Builder
  buildTrailing() {
    if (this.variant === ListItemVariant.Navigation) {
      Text('›').fontSize(20).fontColor(Colors.inkFaint);
    } else if (this.variant === ListItemVariant.Selectable) {
      Stack() {
        if (this.selected) {
          Circle().fill(Colors.unibeRed).width(Control.IconSize.md).height(Control.IconSize.md);
          Text('✓').fontSize(10).fontColor(Colors.surfacePure);
        } else {
          Circle()
            .fill('#00000000')
            .stroke(Colors.hairlineStrong)
            .strokeWidth(1.5)
            .width(Control.IconSize.md)
            .height(Control.IconSize.md);
        }
      };
    } else if (this.variant === ListItemVariant.MultiSelectable) {
      Stack() {
        if (this.selected) {
          Row()
            .width(Control.IconSize.md)
            .height(Control.IconSize.md)
            .backgroundColor(Colors.unibeRed)
            .borderRadius(Radius.sm);
          Text('✓').fontSize(10).fontColor(Colors.surfacePure);
        } else {
          Row()
            .width(Control.IconSize.md)
            .height(Control.IconSize.md)
            .backgroundColor('#00000000')
            .borderRadius(Radius.sm)
            .border({ width: 1.5, color: Colors.hairlineStrong });
        }
      };
    }
  }

  build() {
    Row({ space: Spacing.s3 }) {
      if (this.leadingIcon !== '') {
        LiulianText({ text: this.leadingIcon, variant: TextVariant.MonoLabel, color: Colors.inkMuted });
      }
      Column({ space: Spacing.s1 }) {
        LiulianText({ text: this.primary, variant: TextVariant.BodyStrong });
        if (this.secondary !== '') {
          LiulianText({ text: this.secondary, variant: TextVariant.Caption, color: Colors.inkMuted });
        }
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start);

      this.buildTrailing();
    }
    .width('100%')
    .padding({ left: Spacing.s4, right: Spacing.s4, top: Spacing.s3, bottom: Spacing.s3 })
    .constraintSize({ minHeight: 48 })
    .backgroundColor(this.bg())
    .opacity(this.disabled ? Opacity.disabled : 1.0)
    .onClick(() => {
      if (!this.disabled && this.variant !== ListItemVariant.Content) {
        this.onPress();
      }
    });
  }
}

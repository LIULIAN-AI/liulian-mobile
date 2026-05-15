// LiulianTab — ArkUI impl per ui-spec/Tab.spec.md.
//
// Implementation note: ArkUI's animated indicator slides via .position()
// animation. tab widths are measured via .onAreaChange.

import { Colors, Spacing, Opacity, Control, FontSize, Fonts, Duration } from './tokens';
import { LiulianText, TextVariant } from './LiulianText';
import { LiulianCurves } from './LiulianFont';

export interface LiulianTabItem {
  id: string;
  label: string;
  disabled?: boolean;
}

export enum TabVariant { Default = 'default', Compact = 'compact' }

@Component
export struct LiulianTab {
  @Prop items: LiulianTabItem[] = [];
  @Prop activeId: string = '';
  @Prop variant: TabVariant = TabVariant.Default;
  onChange: (id: string) => void = () => {};

  @State private positions: Map<string, { x: number; w: number }> = new Map();

  private height(): number {
    return this.variant === TabVariant.Compact ? Control.Height.sm : Control.Height.md;
  }

  private activePos(): { x: number; w: number } | undefined {
    return this.positions.get(this.activeId);
  }

  build() {
    Stack({ alignContent: Alignment.BottomStart }) {
      // Tabs row
      Row() {
        ForEach(this.items, (item: LiulianTabItem) => {
          Stack() {
            LiulianText({
              text: item.label,
              variant: TextVariant.MonoLabel,
              color: item.id === this.activeId ? Colors.inkCharcoal : Colors.inkMuted,
            });
          }
          .height(this.height())
          .padding({ left: Spacing.s4, right: Spacing.s4 })
          .opacity(item.disabled === true ? Opacity.disabled : 1.0)
          .onClick(() => {
            if (item.disabled !== true) this.onChange(item.id);
          })
          .onAreaChange((_old, newArea) => {
            const x = Number(newArea.position.x);
            const w = Number(newArea.width);
            const next = new Map(this.positions);
            next.set(item.id, { x, w });
            this.positions = next;
          });
        }, (item: LiulianTabItem) => item.id);
      }
      .height(this.height())
      .width('100%')
      .backgroundColor(Colors.canvasWarm);

      // hairline bottom
      Row().width('100%').height(1).backgroundColor(Colors.hairline);

      // active indicator
      if (this.activePos() !== undefined) {
        Row()
          .width(this.activePos()!.w)
          .height(2)
          .position({ x: this.activePos()!.x, y: this.height() - 2 })
          .backgroundColor(Colors.unibeRed)
          .animation({ duration: Duration.fast, curve: LiulianCurves.easeOutQuart() });
      }
    }
    .width('100%')
    .height(this.height());
  }
}

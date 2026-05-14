// First-loaded page (tab bar host).

import { Colors, Spacing } from 'liulian_ui';
import { LiulianButton, ButtonVariant, ButtonSize } from 'liulian_ui';
import Home from './Home';
import Gallery from './Gallery';

enum Tab { Home = 'home', Gallery = 'gallery' }

@Entry
@Component
struct Index {
  @State activeTab: Tab = Tab.Home;

  build() {
    Column() {
      // content area
      Stack() {
        if (this.activeTab === Tab.Home) {
          Home();
        } else {
          Gallery();
        }
      }
      .layoutWeight(1)
      .width('100%');

      // tab bar
      Row({ space: Spacing.s3 }) {
        LiulianButton({
          label: 'Home',
          variant: this.activeTab === Tab.Home ? ButtonVariant.Primary : ButtonVariant.Ghost,
          size: ButtonSize.Sm,
          onPress: () => { this.activeTab = Tab.Home; }
        });
        LiulianButton({
          label: 'Gallery',
          variant: this.activeTab === Tab.Gallery ? ButtonVariant.Primary : ButtonVariant.Ghost,
          size: ButtonSize.Sm,
          onPress: () => { this.activeTab = Tab.Gallery; }
        });
      }
      .width('100%')
      .height(64)
      .justifyContent(FlexAlign.Center)
      .backgroundColor(Colors.surfacePure)
      .border({ width: { top: 1 }, color: Colors.hairline });
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Colors.canvasWarm);
  }
}

// Home screen — mirrors iOS HomeView and Android HomeScreen.

import { Colors, Spacing } from 'liulian_ui';
import { LiulianText, TextVariant } from 'liulian_ui';
import { LiulianButton, ButtonVariant, ButtonSize } from 'liulian_ui';
import { LiulianCard, CardSize } from 'liulian_ui';

@Component
export default struct Home {
  @State private selected: string = 'aare-bern';

  @Builder
  buildHeadlineCardContent() {
    LiulianText({ text: 'Aare-Bern', variant: TextVariant.Title });
    Row() {
      LiulianText({ text: '142 cm', variant: TextVariant.Display, color: Colors.inkCharcoal });
      Blank();
      Column() {
        LiulianText({ text: '+ 6 cm / 24h', variant: TextVariant.Body, color: Colors.unibeRedText });
        LiulianText({ text: 'forecast', variant: TextVariant.MonoLabel, color: Colors.inkFaint });
      }.alignItems(HorizontalAlign.End);
    }
    .width('100%')
    .alignItems(VerticalAlign.Bottom);
  }

  @Builder
  buildStationContent(id: string) {
    Row() {
      Column() {
        LiulianText({ text: id, variant: TextVariant.BodyStrong });
        LiulianText({ text: '142 cm · forecast +6', variant: TextVariant.Caption, color: Colors.inkMuted });
      }.alignItems(HorizontalAlign.Start);
      Blank();
      Text('›').fontColor(Colors.inkFaint).fontSize(20);
    }
    .width('100%');
  }

  build() {
    Scroll() {
      Column({ space: Spacing.s5 }) {
        // header
        Row() {
          Column() {
            LiulianText({ text: 'liulian · home', variant: TextVariant.MonoLabel, color: Colors.inkFaint });
            LiulianText({ text: 'Forecast', variant: TextVariant.Heading });
          }.alignItems(HorizontalAlign.Start);
          Blank();
          LiulianButton({ label: 'Search', variant: ButtonVariant.Ghost, size: ButtonSize.Sm });
        }.width('100%');

        // headline card
        LiulianCard({ size: CardSize.Spacious, content: () => this.buildHeadlineCardContent() });

        // quick actions
        LiulianText({ text: 'quick actions', variant: TextVariant.MonoLabel, color: Colors.inkFaint });
        Row({ space: Spacing.s3 }) {
          LiulianButton({ label: 'Forecast' });
          LiulianButton({ label: 'Alerts', variant: ButtonVariant.Secondary });
        };

        // stations
        LiulianText({ text: 'stations', variant: TextVariant.MonoLabel, color: Colors.inkFaint });
        Column({ space: Spacing.s3 }) {
          ForEach(
            ['aare-bern', 'rhein-rheinfelden', 'ticino-bellinzona'],
            (id: string) => {
              LiulianCard({
                size: CardSize.Compact,
                interactive: true,
                selected: this.selected === id,
                onPress: () => { this.selected = id; },
                content: () => this.buildStationContent(id),
              });
            },
            (id: string) => id
          );
        };
      }
      .padding(Spacing.s5)
      .alignItems(HorizontalAlign.Start);
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Colors.canvasWarm);
  }
}

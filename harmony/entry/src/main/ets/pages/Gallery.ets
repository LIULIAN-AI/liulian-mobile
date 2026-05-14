// Gallery page wrapper.

import { LiulianGallery } from 'liulian_ui';

@Component
export default struct Gallery {
  build() {
    Column() {
      LiulianGallery();
    }
    .width('100%')
    .height('100%');
  }
}

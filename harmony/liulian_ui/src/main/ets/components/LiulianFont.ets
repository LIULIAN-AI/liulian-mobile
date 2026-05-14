// Font helpers + cubic-bezier curve helpers for ArkUI.
//
// Fonts: registered via app entry's `globalThis` font config (see EntryAbility.ets).
// Curves: wraps the Easing token coefficients into `curves.cubicBezierCurve(...)` calls
//         that ArkUI's .animation({ curve: ... }) modifier accepts.

import { curves } from '@kit.ArkUI';
import { Fonts, Easing } from './tokens';

export class LiulianFont {
  static readonly display = Fonts.display; // 'Fraunces'
  static readonly body = Fonts.body;       // 'Switzer'
  static readonly mono = Fonts.mono;       // 'JetBrains Mono'
}

export class LiulianCurves {
  static easeOut(): object {
    return curves.cubicBezierCurve(
      Easing.easeOut[0], Easing.easeOut[1], Easing.easeOut[2], Easing.easeOut[3]
    );
  }
  static easeOutQuart(): object {
    return curves.cubicBezierCurve(
      Easing.easeOutQuart[0], Easing.easeOutQuart[1], Easing.easeOutQuart[2], Easing.easeOutQuart[3]
    );
  }
  static easeInOut(): object {
    return curves.cubicBezierCurve(
      Easing.easeInOut[0], Easing.easeInOut[1], Easing.easeInOut[2], Easing.easeInOut[3]
    );
  }
}

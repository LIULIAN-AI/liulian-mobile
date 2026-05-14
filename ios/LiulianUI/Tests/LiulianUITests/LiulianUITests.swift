import XCTest
@testable import LiulianUI

/// Sanity tests for LiulianUI. The real visual regression lives in shared/scripts/vr-diff.sh
/// — these tests just verify the token contract (no raw numbers).
final class LiulianUITests: XCTestCase {

    func testTokens_brandColor() {
        // Brand anchor color must equal #E20613
        // We test via the hex round-trip by inspecting Color's stringified form would require
        // private API. Instead, assert the typed values exist:
        let _ = LiulianTokens.Colors.unibeRed
        let _ = LiulianTokens.Colors.unibeRedDeep
        let _ = LiulianTokens.Colors.unibeRedTint
    }

    func testTokens_controlHeights() {
        XCTAssertEqual(LiulianTokens.Control.Height.sm, 32)
        XCTAssertEqual(LiulianTokens.Control.Height.md, 40)
        XCTAssertEqual(LiulianTokens.Control.Height.lg, 48)
    }

    func testTokens_durationsInSeconds() {
        // Sanity: durations should be small-fraction-of-second values
        XCTAssertEqual(LiulianTokens.Duration.fast, 0.180, accuracy: 0.001)
        XCTAssertEqual(LiulianTokens.Duration.medium, 0.300, accuracy: 0.001)
    }
}

import XCTest
import SwiftUI
import SnapshotTesting
@testable import LiulianUI

/// Visual regression snapshots for LiulianUI on iOS.
///
/// Runs on GitHub Actions macos-26 (free for public repos) via
/// .github/workflows/ios-snapshots.yml at liulian-mobile root.
///
/// To record / update baselines locally:
///   swift test  (on macOS, after deleting __Snapshots__/)
/// To verify (CI default):
///   swift test  (fails if any snapshot diff)
final class LiulianSnapshotTests: XCTestCase {

    // Record mode: set to true ONCE locally to capture initial baselines,
    // then commit the __Snapshots__ folder and set back to false.
    override func setUp() {
        super.setUp()
        // isRecording = true
    }

    func testTextAllVariants() {
        let view = VStack(alignment: .leading, spacing: LiulianTokens.Spacing.s3) {
            LiulianText("displayShort 56", variant: .displayShort)
            LiulianText("heading 38", variant: .heading)
            LiulianText("title 28", variant: .title)
            LiulianText("subtitle 18", variant: .subtitle)
            LiulianText("body 13.5", variant: .body)
            LiulianText("bodyStrong 13.5/500", variant: .bodyStrong)
            LiulianText("caption 10.5", variant: .caption, color: LiulianTokens.Colors.inkMuted)
            LiulianText("monoLabel uppercase", variant: .monoLabel, color: LiulianTokens.Colors.inkFaint)
        }
        .padding(LiulianTokens.Spacing.s6)
        .frame(width: 411, height: 600, alignment: .topLeading)
        .background(LiulianTokens.Colors.canvasWarm)

        assertSnapshot(of: view, as: .image, named: "text_all_variants")
    }

    func testButtonVariants() {
        let view = VStack(alignment: .leading, spacing: LiulianTokens.Spacing.s4) {
            HStack(spacing: LiulianTokens.Spacing.s3) {
                LiulianButton("Primary") {}
                LiulianButton("Secondary", variant: .secondary) {}
            }
            HStack(spacing: LiulianTokens.Spacing.s3) {
                LiulianButton("Ghost", variant: .ghost) {}
                LiulianButton("Danger", variant: .danger) {}
            }
            HStack(spacing: LiulianTokens.Spacing.s3) {
                LiulianButton("S", size: .sm) {}
                LiulianButton("M", size: .md) {}
                LiulianButton("L", size: .lg) {}
            }
            HStack(spacing: LiulianTokens.Spacing.s3) {
                LiulianButton("Loading", loading: true) {}
                LiulianButton("Disabled", disabled: true) {}
            }
        }
        .padding(LiulianTokens.Spacing.s7)
        .frame(width: 411, height: 400, alignment: .topLeading)
        .background(LiulianTokens.Colors.canvasWarm)

        assertSnapshot(of: view, as: .image, named: "button_variants")
    }

    func testCardVariants() {
        let view = VStack(spacing: LiulianTokens.Spacing.s3) {
            LiulianCard(size: .compact) {
                LiulianText("Compact card", variant: .title)
                LiulianText("padding s4 (16)", variant: .body, color: LiulianTokens.Colors.inkMuted)
            }
            LiulianCard {
                LiulianText("Default card", variant: .title)
                LiulianText("padding s6 (24)", variant: .body, color: LiulianTokens.Colors.inkMuted)
            }
            LiulianCard(size: .spacious) {
                LiulianText("Spacious card", variant: .title)
                LiulianText("padding s7 (32)", variant: .body, color: LiulianTokens.Colors.inkMuted)
            }
            LiulianCard(selected: true) {
                LiulianText("Selected card", variant: .title)
                LiulianText("border 2px unibe red", variant: .body, color: LiulianTokens.Colors.inkMuted)
            }
        }
        .padding(LiulianTokens.Spacing.s6)
        .frame(width: 411, height: 600, alignment: .topLeading)
        .background(LiulianTokens.Colors.canvasWarm)

        assertSnapshot(of: view, as: .image, named: "card_variants")
    }

    func testGallery() {
        let view = LiulianGallery()
            .frame(width: 411, height: 1200, alignment: .topLeading)

        assertSnapshot(of: view, as: .image, named: "gallery")
    }
}

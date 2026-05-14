import SwiftUI
import LiulianUI

@main
struct LiulianAppMain: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

struct RootView: View {
    enum Tab: Hashable { case home, gallery }
    @State private var tab: Tab = .home

    var body: some View {
        TabView(selection: $tab) {
            HomeView()
                .tabItem {
                    Image(systemName: "drop")
                    Text("Home")
                }
                .tag(Tab.home)

            GalleryView()
                .tabItem {
                    Image(systemName: "rectangle.grid.2x2")
                    Text("Gallery")
                }
                .tag(Tab.gallery)
        }
        // Tint the system tab bar with brand red
        .tint(LiulianTokens.Colors.unibeRed)
    }
}

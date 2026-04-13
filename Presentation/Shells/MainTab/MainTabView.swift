import SwiftUI

struct MainTabView: View {
    let loadProductListUseCase: any LoadProductListUseCase
    let saveProfileUseCase: any SaveProfileUseCase
    let onLogout: @MainActor () -> Void

    @State private var selectedTab: MainTabRoute = .home
    @State private var homePath: [HomeTabRoute] = []
    @State private var settingsPath: [SettingsTabRoute] = []

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack(path: $homePath) {
                HomeView(
                    onLogout: {
                        onLogout()
                        selectedTab = .home
                        homePath.removeAll()
                        settingsPath.removeAll()
                    }
                )
                .navigationDestination(for: HomeTabRoute.self) { route in
                    switch route {
                    case .productList:
                        ProductListView(
                            model: ProductListModel(
                                loadProductListUseCase: loadProductListUseCase
                            ),
                            onOpenSettingsDetail: {
                                selectedTab = .settings
                                settingsPath = [.settings]
                            }
                        )
                    }
                }
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }
            .tag(MainTabRoute.home)

            NavigationStack(path: $settingsPath) {
                SettingsEntryView()
                    .navigationDestination(for: SettingsTabRoute.self) { route in
                        switch route {
                        case .settings:
                            SettingsView(model: SettingsModel(saveProfileUseCase: saveProfileUseCase))
                        }
                    }
            }
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
            .tag(MainTabRoute.settings)
        }
    }
}

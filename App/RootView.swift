import SwiftUI

struct RootView: View {
    let container: AppContainer

    var body: some View {
        switch appRoute {
        case .auth:
            NavigationStack {
                LoginView(
                    model: LoginModel(
                        loginUseCase: container.loginUseCase,
                        onLoginSuccess: {
                            container.appStore.isAuthenticated = true
                        }
                    )
                )
            }
        case .mainTabs:
            MainTabView(
                loadProductListUseCase: container.loadProductListUseCase,
                saveProfileUseCase: container.saveProfileUseCase,
                onLogout: {
                    container.appStore.isAuthenticated = false
                }
            )
        }
    }

    private var appRoute: AppRoute {
        container.appStore.isAuthenticated ? .mainTabs : .auth
    }
}

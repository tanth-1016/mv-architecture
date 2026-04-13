import Foundation

@MainActor
final class AppContainer {
    let appStore: AppStore
    let loginUseCase: any LoginUseCase
    let loadProductListUseCase: any LoadProductListUseCase
    let saveProfileUseCase: any SaveProfileUseCase

    /// Production wiring: real data sources → real repository → real use case.
    init() {
        let authRepository = AuthRepositoryImpl()
        let remoteDataSource = SampleProductRemoteDataSource()
        let productRepository = ProductRepositoryImpl(remoteDataSource: remoteDataSource)
        let profileRepository = ProfileRepositoryImpl()
        self.appStore = AppStore()
        self.loginUseCase = DefaultLoginUseCase(repository: authRepository)
        self.loadProductListUseCase = DefaultLoadProductListUseCase(repository: productRepository)
        self.saveProfileUseCase = DefaultSaveProfileUseCase(repository: profileRepository)
    }

    /// Test / preview wiring: inject any use case stub.
    init(
        appStore: AppStore = .init(),
        loginUseCase: any LoginUseCase,
        loadProductListUseCase: any LoadProductListUseCase,
        saveProfileUseCase: any SaveProfileUseCase
    ) {
        self.appStore = appStore
        self.loginUseCase = loginUseCase
        self.loadProductListUseCase = loadProductListUseCase
        self.saveProfileUseCase = saveProfileUseCase
    }
}

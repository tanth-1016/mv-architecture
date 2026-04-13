import Foundation
import Observation

@MainActor
@Observable
final class LoginModel {
    private let loginUseCase: any LoginUseCase
    private let onLoginSuccess: @MainActor () -> Void

    var email = "demo@mv.com"
    var password = "123456"
    var isLoading = false
    var errorMessage: String?

    init(
        loginUseCase: any LoginUseCase,
        onLoginSuccess: @escaping @MainActor () -> Void
    ) {
        self.loginUseCase = loginUseCase
        self.onLoginSuccess = onLoginSuccess
    }

    func didTapLogin() async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            try await loginUseCase.execute(email: email, password: password)
            onLoginSuccess()
        } catch is CancellationError {
            // Ignore cancellation so the UI does not show a false error state.
        } catch {
            errorMessage = "Invalid email or password."
        }
    }
}

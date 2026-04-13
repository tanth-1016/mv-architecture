import XCTest
@testable import MVArchitectureDemo

@MainActor
final class LoginModelTests: XCTestCase {
    func test_didTapLogin_callsSuccessCallbackOnSuccess() async {
        let useCase = LoginUseCaseStub(response: .success)
        var didLogin = false
        let model = LoginModel(
            loginUseCase: useCase,
            onLoginSuccess: { didLogin = true }
        )

        await model.didTapLogin()

        XCTAssertTrue(didLogin)
        XCTAssertNil(model.errorMessage)
        XCTAssertFalse(model.isLoading)
    }

    func test_didTapLogin_setsErrorOnFailure() async {
        let useCase = LoginUseCaseStub(response: .failure)
        let model = LoginModel(
            loginUseCase: useCase,
            onLoginSuccess: {}
        )

        await model.didTapLogin()

        XCTAssertEqual(model.errorMessage, "Invalid email or password.")
        XCTAssertFalse(model.isLoading)
    }

    func test_didTapLogin_ignoresCancellation() async {
        let useCase = LoginUseCaseStub(response: .cancelled)
        var didLogin = false
        let model = LoginModel(
            loginUseCase: useCase,
            onLoginSuccess: { didLogin = true }
        )

        await model.didTapLogin()

        XCTAssertFalse(didLogin)
        XCTAssertNil(model.errorMessage)
        XCTAssertFalse(model.isLoading)
    }
}

private struct LoginUseCaseStub: LoginUseCase {
    enum Response: Sendable {
        case success
        case failure
        case cancelled
    }

    let response: Response

    func execute(email: String, password: String) async throws {
        switch response {
        case .success:
            return
        case .failure:
            throw StubError.failed
        case .cancelled:
            throw CancellationError()
        }
    }

    private enum StubError: Error, Sendable {
        case failed
    }
}

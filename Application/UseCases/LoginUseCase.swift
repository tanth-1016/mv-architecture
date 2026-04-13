import Foundation

protocol LoginUseCase: Sendable {
    func execute(email: String, password: String) async throws
}

struct DefaultLoginUseCase: LoginUseCase {
    private let repository: any AuthRepository

    init(repository: any AuthRepository) {
        self.repository = repository
    }

    func execute(email: String, password: String) async throws {
        try await repository.login(email: email, password: password)
    }
}

struct PreviewLoginUseCase: LoginUseCase {
    func execute(email: String, password: String) async throws {
        // No-op for previews.
    }
}

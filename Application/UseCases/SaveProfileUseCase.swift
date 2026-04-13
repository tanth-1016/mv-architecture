import Foundation

protocol SaveProfileUseCase: Sendable {
    func execute(name: String) async throws
}

struct DefaultSaveProfileUseCase: SaveProfileUseCase {
    private let repository: any ProfileRepository

    init(repository: any ProfileRepository) {
        self.repository = repository
    }

    func execute(name: String) async throws {
        try await repository.saveDisplayName(name)
    }
}

struct PreviewSaveProfileUseCase: SaveProfileUseCase {
    func execute(name: String) async throws {
        // No-op for previews.
    }
}
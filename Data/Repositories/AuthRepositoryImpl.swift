import Foundation

enum AuthError: Error, Sendable {
    case invalidCredentials
}

struct AuthRepositoryImpl: AuthRepository {
    func login(email: String, password: String) async throws {
        try await Task.sleep(for: .milliseconds(700))

        guard email == "demo@mv.com", password == "123456" else {
            throw AuthError.invalidCredentials
        }
    }
}

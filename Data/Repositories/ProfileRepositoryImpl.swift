import Foundation

struct ProfileRepositoryImpl: ProfileRepository {
    func saveDisplayName(_ name: String) async throws {
        try await Task.sleep(for: .milliseconds(700))
    }
}
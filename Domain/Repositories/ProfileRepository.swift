import Foundation

protocol ProfileRepository: Sendable {
    func saveDisplayName(_ name: String) async throws
}
import Foundation

protocol ProductRepository: Sendable {
    func fetchAll() async throws -> [Product]
}

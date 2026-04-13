import Foundation

protocol ProductRemoteDataSource: Sendable {
    func fetchProducts() async throws -> [Product]
}

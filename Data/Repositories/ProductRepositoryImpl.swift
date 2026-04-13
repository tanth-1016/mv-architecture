import Foundation

struct ProductRepositoryImpl: ProductRepository {
    private let remoteDataSource: any ProductRemoteDataSource

    init(remoteDataSource: any ProductRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    func fetchAll() async throws -> [Product] {
        try await remoteDataSource.fetchProducts()
    }
}

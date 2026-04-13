import Foundation

protocol LoadProductListUseCase: Sendable {
    func execute() async throws -> [Product]
}

struct DefaultLoadProductListUseCase: LoadProductListUseCase {
    private let repository: any ProductRepository

    init(repository: any ProductRepository) {
        self.repository = repository
    }

    func execute() async throws -> [Product] {
        try await repository.fetchAll()
    }
}

struct PreviewLoadProductListUseCase: LoadProductListUseCase {
    func execute() async throws -> [Product] {
        [
            Product(id: UUID(), name: "Swift T-Shirt", price: 29.99),
            Product(id: UUID(), name: "SwiftUI Book", price: 49.99),
            Product(id: UUID(), name: "Apple Pencil", price: 129.99),
        ]
    }
}

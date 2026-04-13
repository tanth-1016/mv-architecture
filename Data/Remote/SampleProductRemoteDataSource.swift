import Foundation

/// Sample in-memory data source. Replace with a real URLSession-based implementation.
struct SampleProductRemoteDataSource: ProductRemoteDataSource {
    func fetchProducts() async throws -> [Product] {
        // Simulate a short network delay.
        try await Task.sleep(for: .seconds(1))
        return [
            Product(id: UUID(), name: "iPhone 16 Pro Case", price: 49.99),
            Product(id: UUID(), name: "MagSafe Charger", price: 39.99),
            Product(id: UUID(), name: "AirPods Pro", price: 249.99),
            Product(id: UUID(), name: "Apple Watch Band", price: 49.99),
            Product(id: UUID(), name: "USB-C Hub", price: 79.99),
        ]
    }
}

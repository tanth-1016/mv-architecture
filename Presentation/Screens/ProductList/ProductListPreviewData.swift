import Foundation

enum ProductListPreviewData {
    static let items: [Product] = [
        Product(id: UUID(), name: "Swift T-Shirt", price: 29.99),
        Product(id: UUID(), name: "SwiftUI Book", price: 49.99),
        Product(id: UUID(), name: "Apple Pencil", price: 129.99),
    ]
}

import XCTest
@testable import MVArchitectureDemo

@MainActor
final class ProductListModelTests: XCTestCase {
    func test_onAppear_loadsItemsOnSuccess() async {
        let expected: [Product] = [.init(id: UUID(), name: "Test Product", price: 9.99)]
        let useCase = LoadProductListUseCaseStub(response: .success(expected))
        let model = ProductListModel(loadProductListUseCase: useCase)

        await model.onAppear()

        XCTAssertEqual(model.items, expected)
        XCTAssertNil(model.errorMessage)
        XCTAssertFalse(model.isLoading)
    }

    func test_onAppear_setsErrorOnFailure() async {
        let useCase = LoadProductListUseCaseStub(response: .failure)
        let model = ProductListModel(loadProductListUseCase: useCase)

        await model.onAppear()

        XCTAssertTrue(model.items.isEmpty)
        XCTAssertEqual(model.errorMessage, "Failed to load products.")
        XCTAssertFalse(model.isLoading)
    }

    func test_didTapRetry_ignoresCancellation() async {
        let initial: [Product] = [.init(id: UUID(), name: "Keep", price: 1.0)]
        let useCase = LoadProductListUseCaseStub(response: .cancelled)
        let model = ProductListModel(loadProductListUseCase: useCase)
        model.items = initial

        await model.didTapRetry()

        XCTAssertEqual(model.items, initial)
        XCTAssertNil(model.errorMessage)
        XCTAssertFalse(model.isLoading)
    }
}

private struct LoadProductListUseCaseStub: LoadProductListUseCase {
    enum Response: Sendable {
        case success([Product])
        case failure
        case cancelled
    }

    let response: Response

    func execute() async throws -> [Product] {
        switch response {
        case let .success(items):
            return items
        case .failure:
            throw StubError.failed
        case .cancelled:
            throw CancellationError()
        }
    }

    private enum StubError: Error, Sendable {
        case failed
    }
}

import Foundation
import Observation

@MainActor
@Observable
final class ProductListModel {
    private let loadProductListUseCase: any LoadProductListUseCase

    var isLoading = false
    var items: [Product] = []
    var errorMessage: String?

    init(loadProductListUseCase: any LoadProductListUseCase) {
        self.loadProductListUseCase = loadProductListUseCase
    }

    func onAppear() async {
        guard items.isEmpty else { return }
        await load()
    }

    func didTapRetry() async {
        await load()
    }

    private func load() async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            items = try await loadProductListUseCase.execute()
        } catch is CancellationError {
            // Ignore cancellation so the UI does not show a false error state.
        } catch {
            items = []
            errorMessage = "Failed to load products."
        }
    }
}

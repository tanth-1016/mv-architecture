import SwiftUI

struct ProductListView: View {
    @State private var model: ProductListModel
    let onOpenSettingsDetail: @MainActor () -> Void

    init(
        model: ProductListModel,
        onOpenSettingsDetail: @escaping @MainActor () -> Void = {}
    ) {
        _model = State(initialValue: model)
        self.onOpenSettingsDetail = onOpenSettingsDetail
    }

    var body: some View {
        content
            .navigationTitle("Products")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Go Settings") {
                        onOpenSettingsDetail()
                    }
                }
            }
            .task {
                await model.onAppear()
            }
            .refreshable {
                await model.didTapRetry()
            }
    }

    @ViewBuilder
    private var content: some View {
        if model.isLoading {
            ProgressView()
        } else if let errorMessage = model.errorMessage {
            VStack(spacing: 12) {
                Text(errorMessage)
                Button("Retry") {
                    Task { await model.didTapRetry() }
                }
            }
        } else {
            List(model.items) { item in
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.name)
                        .font(.headline)
                    Text(item.price, format: .currency(code: "USD"))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

#Preview("Loaded") {
    NavigationStack {
        ProductListView(
            model: {
                let model = ProductListModel(
                    loadProductListUseCase: PreviewLoadProductListUseCase()
                )
                model.items = ProductListPreviewData.items
                return model
            }()
        )
    }
}

#Preview("Loading") {
    NavigationStack {
        ProductListView(
            model: {
                let m = ProductListModel(
                    loadProductListUseCase: PreviewLoadProductListUseCase()
                )
                m.isLoading = true
                return m
            }()
        )
    }
}

#Preview("Error") {
    NavigationStack {
        ProductListView(
            model: {
                let m = ProductListModel(
                    loadProductListUseCase: PreviewLoadProductListUseCase()
                )
                m.errorMessage = "Failed to load products."
                return m
            }()
        )
    }
}

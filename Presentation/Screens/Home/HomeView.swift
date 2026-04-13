import SwiftUI

struct HomeView: View {
    let onLogout: @MainActor () -> Void

    var body: some View {
        List {
            NavigationLink(value: HomeTabRoute.productList) {
                Text("Products")
            }

            Button("Logout") {
                onLogout()
            }
            .foregroundStyle(.red)
        }
        .navigationTitle("Home")
    }
}

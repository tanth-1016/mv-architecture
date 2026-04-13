import SwiftUI

struct SettingsEntryView: View {
    var body: some View {
        List {
            NavigationLink(value: SettingsTabRoute.settings) {
                Text("Open Settings")
            }
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    NavigationStack {
        SettingsEntryView()
    }
}

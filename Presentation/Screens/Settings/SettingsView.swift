import SwiftUI

struct SettingsView: View {
    @State private var model: SettingsModel

    init(model: SettingsModel) {
        _model = State(initialValue: model)
    }

    var body: some View {
        List {
            Section("General") {
                LabeledContent("Version", value: "1.0.0")
            }

            Section("Account") {
                Button("Edit Profile") {
                    model.didTapEditProfile()
                }
            }
        }
        .navigationTitle("Settings")
        // Sheet is owned by this feature's model — not routed through the tab router.
        .sheet(isPresented: $model.isPresentingEditProfile) {
            EditProfileView(model: model.makeEditProfileModel())
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView(model: SettingsModel(saveProfileUseCase: PreviewSaveProfileUseCase()))
    }
}


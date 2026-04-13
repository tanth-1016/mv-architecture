import SwiftUI

struct EditProfileView: View {
    @State private var model: EditProfileModel
    @Environment(\.dismiss) private var dismiss

    init(model: EditProfileModel) {
        _model = State(initialValue: model)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Profile") {
                    TextField("Name", text: $model.name)
                }

                if let errorMessage = model.errorMessage {
                    Section {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    // Cancel is a pure UI action — no business logic, dismiss directly.
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Task { await model.didTapSave() }
                    } label: {
                        if model.isSaving {
                            ProgressView()
                        } else {
                            Text("Save")
                        }
                    }
                    .disabled(model.isSaving)
                }
            }
        }
    }
}

#Preview("Edit Profile") {
    EditProfileView(
        model: EditProfileModel(
            saveProfileUseCase: PreviewSaveProfileUseCase(),
            name: "Demo User",
            onSaveSuccess: {}
        )
    )
}

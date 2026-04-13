import Foundation
import Observation

@MainActor
@Observable
final class EditProfileModel {
    private let saveProfileUseCase: any SaveProfileUseCase
    private let onSaveSuccess: @MainActor () -> Void

    var name: String
    var isSaving = false
    var errorMessage: String?

    init(
        saveProfileUseCase: any SaveProfileUseCase,
        name: String = "Demo User",
        onSaveSuccess: @escaping @MainActor () -> Void
    ) {
        self.saveProfileUseCase = saveProfileUseCase
        self.name = name
        self.onSaveSuccess = onSaveSuccess
    }

    func didTapSave() async {
        guard !isSaving else { return }
        isSaving = true
        errorMessage = nil
        defer { isSaving = false }

        do {
            try await saveProfileUseCase.execute(name: name)
            onSaveSuccess()
        } catch is CancellationError {
            // Ignore cancellation so the UI does not show a false error state.
        } catch {
            errorMessage = "Failed to save profile."
        }
    }
}

import Foundation
import Observation

@MainActor
@Observable
final class SettingsModel {
    private let saveProfileUseCase: any SaveProfileUseCase

    var isPresentingEditProfile = false

    init(saveProfileUseCase: any SaveProfileUseCase) {
        self.saveProfileUseCase = saveProfileUseCase
    }

    func didTapEditProfile() {
        isPresentingEditProfile = true
    }

    func didDismissEditProfile() {
        isPresentingEditProfile = false
    }

    func makeEditProfileModel() -> EditProfileModel {
        EditProfileModel(
            saveProfileUseCase: saveProfileUseCase,
            onSaveSuccess: { [weak self] in
                self?.didDismissEditProfile()
            }
        )
    }
}

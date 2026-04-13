import XCTest
@testable import MVArchitectureDemo

@MainActor
final class SettingsModelTests: XCTestCase {
    func test_didTapEditProfile_setsPresentingTrue() {
        let model = SettingsModel(saveProfileUseCase: SaveProfileUseCaseStub(response: .success))

        model.didTapEditProfile()

        XCTAssertTrue(model.isPresentingEditProfile)
    }

    func test_didDismissEditProfile_setsPresentingFalse() {
        let model = SettingsModel(saveProfileUseCase: SaveProfileUseCaseStub(response: .success))
        model.isPresentingEditProfile = true

        model.didDismissEditProfile()

        XCTAssertFalse(model.isPresentingEditProfile)
    }

    func test_makeEditProfileModel_dismissesSheetOnSaveSuccess() async {
        let model = SettingsModel(saveProfileUseCase: SaveProfileUseCaseStub(response: .success))
        model.didTapEditProfile()
        let editProfileModel = model.makeEditProfileModel()

        await editProfileModel.didTapSave()

        XCTAssertFalse(model.isPresentingEditProfile)
    }
}

@MainActor
final class EditProfileModelTests: XCTestCase {
    func test_didTapSave_callsOnSaveSuccessOnSuccess() async {
        var didSave = false
        let model = EditProfileModel(
            saveProfileUseCase: SaveProfileUseCaseStub(response: .success),
            name: "Test User",
            onSaveSuccess: { didSave = true }
        )

        await model.didTapSave()

        XCTAssertTrue(didSave)
        XCTAssertNil(model.errorMessage)
        XCTAssertFalse(model.isSaving)
    }

    func test_didTapSave_ignoresCancellation() async {
        var didSave = false
        let model = EditProfileModel(
            saveProfileUseCase: SaveProfileUseCaseStub(response: .cancelled),
            name: "Test User",
            onSaveSuccess: { didSave = true }
        )

        await model.didTapSave()

        XCTAssertFalse(didSave)
        XCTAssertNil(model.errorMessage)
        XCTAssertFalse(model.isSaving)
    }

    func test_didTapSave_setsErrorOnFailure() async {
        let model = EditProfileModel(
            saveProfileUseCase: SaveProfileUseCaseStub(response: .failure),
            name: "Test User",
            onSaveSuccess: {}
        )

        await model.didTapSave()

        XCTAssertEqual(model.errorMessage, "Failed to save profile.")
        XCTAssertFalse(model.isSaving)
    }
}

private struct SaveProfileUseCaseStub: SaveProfileUseCase {
    enum Response: Sendable {
        case success
        case failure
        case cancelled
    }

    let response: Response

    func execute(name: String) async throws {
        switch response {
        case .success:
            return
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

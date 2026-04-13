import Foundation
import Observation

@MainActor
@Observable
final class AppStore {
    var isAuthenticated = false
}

import SwiftUI

@Observable
final class AlertViewModel {
    var isShown: Bool = false
    var text: String = ""
}

@Observable
final class LoginViewModel {
    // MARK: - Public
    var login: String = ""
    var password: String = ""
    var isBusy: Bool = false
    var showAlert: Bool = false
    var alertViewModel = AlertViewModel()

    // MARK: - Private
    private let domain = LoginDomain()

    @MainActor
    func confirm(nav: any NavigatorProtocol) async {
        isBusy = true
        defer {
            isBusy = false
        }

        do {
            try await domain.confirm(login: login, password: password)
            nav.push(.chat)
        } catch {
            alertViewModel.isShown = true
            alertViewModel.text = "Error: \(error)"
        }
    }
}

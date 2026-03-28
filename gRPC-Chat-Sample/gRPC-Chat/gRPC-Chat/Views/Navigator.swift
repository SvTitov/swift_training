import SwiftUI

enum Route: Hashable {
    case chat
}

protocol NavigatorProtocol: ObservableObject {
    var path: NavigationPath { get set }

    func push(_ route: Route)
    func pop()
    func popToRoot()
}

extension NavigatorProtocol {
    func push(_ route: Route) {
        path.append(route)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path = NavigationPath()
    }
}

class Navigator: NavigatorProtocol {
    @Published var path: NavigationPath = .init()
}

struct NavigatorView<Navigator: NavigatorProtocol>: View {
    @StateObject private var coordinator: Navigator

    init(coordinator: Navigator) {
        _coordinator = StateObject(wrappedValue: coordinator)
    }

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            LoginScreen()
                .navigationDestination(for: Route.self) { hash in
                    switch hash {
                    case .chat: ChatScreen()
                    }
                }
        }.environmentObject(coordinator)
    }
}

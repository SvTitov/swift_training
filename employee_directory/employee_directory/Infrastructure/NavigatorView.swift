import SwiftUI
import os

enum Route: Hashable {
    case details(UserModel)
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

struct NavigatorView<Navigator: NavigatorProtocol>: View {
    @StateObject private var coordinator: Navigator
    
    init(coordinator: Navigator) {
        _coordinator = StateObject(wrappedValue: coordinator)
    }
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            // Used as default page
            ListScreen()
                .navigationDestination(for: Route.self) { hash in
                    switch hash {
                    case .details(let model): DetailsScreen(model: model)
                    }
                }
        }.environmentObject(coordinator)
    }
}

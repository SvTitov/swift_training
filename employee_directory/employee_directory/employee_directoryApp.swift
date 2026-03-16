import SwiftUI

class Navigator: NavigatorProtocol{
    @Published var path: NavigationPath = .init()
}

@main
struct employee_directoryApp: App {
    let repo: NetworkRepository = NetworkRepository()
    
    var body: some Scene {
        WindowGroup {
            NavigatorView(coordinator: Navigator())
                .environment(\.userService, UserService(repo: repo))
                .environmentObject(FavoritesService())
        }
    }
}

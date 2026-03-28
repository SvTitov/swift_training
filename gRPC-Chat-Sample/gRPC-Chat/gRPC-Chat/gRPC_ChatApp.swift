import SwiftUI

@main
struct gRPC_ChatApp: App {
    var body: some Scene {
        WindowGroup {
            NavigatorView(coordinator: Navigator())
        }
    }
}

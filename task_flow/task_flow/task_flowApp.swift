import SwiftData
import SwiftUI

class Navigator: NavigatorProtocol {
    @Published var path: NavigationPath = .init()
}

@main
struct task_flowApp: App {
    @Environment(\.network) var network
    @State private var source = TaskSourceViewModel()

    var body: some Scene {
        WindowGroup {
            NavigatorView(coordinator: Navigator())
                .modelContainer(for: TaskEntity.self)
                .environment(source)
        }
    }
}

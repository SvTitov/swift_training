import SwiftData
import SwiftUI

@main
struct task_flowApp: App {

    @Environment(\.network) var network

    var body: some Scene {
        WindowGroup {
            TaskListScreen()
                .modelContainer(for: [
                    TaskEntity.self
                ])
        }
    }
}

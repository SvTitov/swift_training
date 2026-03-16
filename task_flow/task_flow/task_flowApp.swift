import SwiftData
import SwiftUI

@main
struct task_flowApp: App {
    var body: some Scene {
        WindowGroup {
            TaskListScreen()
                .modelContainer(for: [
                    TaskEntity.self
                ])
        }
    }
}

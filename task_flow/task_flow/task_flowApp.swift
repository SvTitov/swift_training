import BackgroundTasks
import SwiftData
import SwiftUI
import os

class Navigator: NavigatorProtocol {
    @Published var path: NavigationPath = .init()
}

@main
struct task_flowApp: App {
    @Environment(\.network) var network
    @State private var source = TaskSourceViewModel()
    @Environment(\.modelContext) var context

    var body: some Scene {
        WindowGroup {
            NavigatorView(coordinator: Navigator())
                .modelContainer(for: TaskEntity.self)
                .environment(source)
                .onAppear {
                    // TODO: Move bg service
                    BGTaskScheduler.shared.register(
                        forTaskWithIdentifier: "com.testapp.title", using: nil
                    ) { task in
                        guard let task = task as? BGProcessingTask else { return }

                        let syncServcice = SyncService(
                            storage: PersistentRepository<TaskEntity, TaskModel>(
                                modelContainer: context.container),
                            network: network
                        )

                        Task {
                            await syncServcice.start()
                            task.setTaskCompleted(success: true)
                        }
                    }
                }
        }
    }

    func handleProcessingTask(task: BGProcessingTask) {

    }
}

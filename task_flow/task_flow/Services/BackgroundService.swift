import BackgroundTasks
import Foundation
import SwiftUI
import os

class BackgroundService {
    var syncService: SyncService

    init(syncService: SyncService) {
        self.syncService = syncService
    }

    func pepare() {
        let request = BGAppRefreshTaskRequest(identifier: "com.testapp.title")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 5 * 60)

        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            Logger.app.error("Couldn't register background task. Reason: \(error)")
        }
    }

    func run() async {
        await syncService.start()
    }
}

// extension EnvironmentValues {
//     @Entry var backgroundService = BackgroundService(
//         syncService: SyncService(
//             storage: PersistentRepository<TaskEntity, TaskModel>(), network: NetworkRepository()))
// }

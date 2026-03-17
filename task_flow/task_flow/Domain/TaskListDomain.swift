import Foundation
import SwiftData

struct TaskListDomain {
    func fetchTasks(
        repo: any PersistentRepositoryProtocol<TaskEntity, TaskModel>, remote: NetworkRepository
    )
        async throws -> [TaskModel]
    {
        // 1. Check for DB
        // 2. Load data from remote
        // 3. Merge
        let localData = try await repo.fetchAll()
        let (_, remoteData) = try await remote.get(
            [TaskDto].self, resource: "https://jsonplaceholder.typicode.com/todos?userId=1")

        let localIds = Set(localData.compactMap { $0.remoteId })
        let remoteIds = Set(remoteData.map { $0.id })

        // New tasks from remote
        let newTasks = remoteIds.subtracting(localIds)

        let batch = remoteData.filter { newTasks.contains($0.id) }
            .map { TaskModel.init(title: $0.title, remoteId: $0.id, syncStatus: .synced) }

        // Insert new tasks
        try await repo.insertBatch(batch)

        // If we have updates
        if try await repo.count() != localData.count {
            return try await repo.fetchAll()
        }

        return localData
    }
}

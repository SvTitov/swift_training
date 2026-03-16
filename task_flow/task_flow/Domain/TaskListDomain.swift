import Foundation
import SwiftData

struct TaskListDomain {
    func fetchTasks<Repo: PersistentRepositoryProtocol>(repo: Repo, remote: NetworkRepository)
        async throws
    where Repo.Entity == TaskEntity, Repo.Model == TaskModel {
        // 1. Check for DB
        // 2. Load data from remote
        // 3. Merge

        let localData = try await repo.fetchAll()
        let (_, remoteData) = try await remote.get([TaskDto].self, resource: "")

        let localIds = Set(localData.compactMap { $0.remoteId })
        let remoteIds = Set(remoteData.map { $0.id })

        // New tasks from remote
        let newTasks = remoteIds.subtracting(localIds)

        let batch = remoteData.filter { newTasks.contains($0.id) }
            .map { TaskModel.init(title: $0.title, remoteId: $0.id, syncStatus: .synced) }

        try await repo.insertBatch(batch)
    }
}

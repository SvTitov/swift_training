import Foundation

struct TaskModel: Hashable, Equatable, Identifiable, ModelProtocol {
    typealias Entity = TaskEntity

    var id: UUID
    var title: String
    var createdAt: Date
    var remoteId: Int?
    var syncStatus: SyncStatus
    var isCompleted: Bool
    var priority: Priority
    var updatedAt: Date

    init(
        title: String, remoteId: Int?, syncStatus: SyncStatus, isCompleted: Bool,
        createdAt: Date,
        priority: Priority,
        updateAt updatedAt: Date
    ) {
        id = UUID()
        self.title = title
        self.createdAt = createdAt
        self.remoteId = remoteId
        self.syncStatus = syncStatus
        self.isCompleted = isCompleted
        self.priority = priority
        self.updatedAt = updatedAt
    }

    init(_ entity: TaskEntity) {
        id = entity.id
        title = entity.title
        createdAt = entity.createdAt
        remoteId = entity.remoteId
        syncStatus = entity.syncStatus
        isCompleted = entity.isCompleted
        priority = entity.priority
        updatedAt = entity.updatedAt
    }
}

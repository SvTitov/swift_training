import Foundation

struct TaskModel: Identifiable, ModelProtocol {
    typealias Entity = TaskEntity

    var id: UUID
    var title: String
    var createdAt: Date
    var remoteId: Int?
    var syncStatus: SyncStatus

    init(title: String, remoteId: Int?, syncStatus: SyncStatus) {
        id = UUID()
        self.title = title
        createdAt = .now
        self.remoteId = remoteId
        self.syncStatus = syncStatus
    }

    init(_ entity: TaskEntity) {
        id = entity.id
        title = entity.title
        createdAt = entity.createdAt
        remoteId = entity.remoteId
        syncStatus = entity.syncStatus
    }
}

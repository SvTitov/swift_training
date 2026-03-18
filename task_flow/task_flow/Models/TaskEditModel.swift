import Foundation
import SwiftUI

@Observable
final class TaskEditModel {
    var id: UUID
    var remoteId: Int?
    var title: String
    var isCompleted: Bool
    var priority: Priority
    var createdAt: Date
    var updatedAt: Date
    var syncStatus: SyncStatus

    init(
        id: UUID = UUID(),
        title: String = "",
        isCompleted: Bool = false,
        priority: Priority = .medium,
        createdAt: Date = .now,
        updateAt: Date = .now,
        syncStatus: SyncStatus = .any
    ) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.priority = priority
        self.createdAt = createdAt
        self.updatedAt = updateAt
        self.syncStatus = syncStatus
    }

    init(task: TaskModel) {
        self.id = task.id
        self.remoteId = task.remoteId
        self.title = task.title
        self.isCompleted = task.isCompleted
        self.priority = task.priority
        self.createdAt = task.createdAt
        self.updatedAt = task.updatedAt
        self.syncStatus = task.syncStatus
    }

    func toTask() -> TaskModel {
        .init(
            title: title,
            remoteId: remoteId,
            syncStatus: syncStatus,
            isCompleted: isCompleted,
            createdAt: createdAt,
            priority: priority,
            updateAt: updatedAt
        )
    }
}

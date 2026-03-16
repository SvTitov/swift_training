import Foundation
import SwiftData

enum Priority: Int, Codable { case low, medium, high }
enum SyncStatus: Int, Codable { case pending, synced, conflict }

@Model
final class TaskEntity {
    @Attribute(.unique) var id: UUID
    var remoteId: Int?
    var title: String
    var isCompleted: Bool
    var priority: Priority
    var createdAt: Date
    var updatedAt: Date
    var syncStatus: SyncStatus

    init(
        id: UUID, remoteId: Int?, title: String, isCompleted: Bool, priority: Priority,
        createdAt: Date, updatedAt: Date, syncStatus: SyncStatus
    ) {
        self.id = id
        self.remoteId = remoteId
        self.title = title
        self.isCompleted = isCompleted
        self.priority = priority
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.syncStatus = syncStatus
    }
}

extension TaskEntity: EntityProtocol {
    typealias Model = TaskModel

    func update(_ model: TaskModel) {
        self.title = model.title
    }

    convenience init(model: TaskModel) {
        self.init(
            id: UUID(), remoteId: nil, title: model.title, isCompleted: false, priority: .medium,
            createdAt: Date.now, updatedAt: Date.now, syncStatus: .pending)
    }
}

// In case if you need several inits from protocol use this approach
// protocol Flier {
//     init(val: Int)
// }
// class Bird {
//     required init() {}
//
//     required convenience init(val: Int) {
//         self.init()
//     }
// }
//
// extension Bird: Flier {}

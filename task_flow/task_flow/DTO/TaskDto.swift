import Foundation

struct TaskResponseDto: Codable {}

struct TaskDto: Codable {
    let userID, id: Int
    let title: String
    let completed: Bool

    static func stub() -> Self {
        TaskDto(userID: -1, id: -1, title: "", completed: true)
    }

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, completed
    }

    func mapToEntity() -> TaskEntity {
        TaskEntity.init(
            id: UUID(), remoteId: id, title: title, isCompleted: completed,
            priority: .medium,
            createdAt: Date.now, updatedAt: Date.now, syncStatus: .pending)
    }

    func mapToModel() -> TaskModel {
        .init(title: title, remoteId: id, syncStatus: .synced)
    }
}

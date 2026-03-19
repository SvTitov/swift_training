import Testing

@testable import task_flow

struct task_flowTests {

    @Test func shouldModelMapToEntityCorrectly() throws {
        // Arrange
        let model = TaskModel(
            title: "Title",
            remoteId: 1,
            syncStatus: .pending,
            isCompleted: false,
            createdAt: .now,
            priority: .low,
            updateAt: .now
        )

        // Act
        let entity = TaskEntity(model: model)

        // Assert
        #expect(entity.title == model.title)
        #expect(entity.createdAt == model.createdAt)
        #expect(entity.isCompleted == model.isCompleted)
        #expect(entity.priority == model.priority)
        #expect(entity.remoteId == model.remoteId)
        #expect(entity.syncStatus == model.syncStatus)
        #expect(entity.updatedAt == model.updatedAt)
        #expect(entity.id == model.id)
    }
}

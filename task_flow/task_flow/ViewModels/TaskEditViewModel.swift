import Foundation
import SwiftUI
import os

@Observable
class TaskEditViewModel {
    enum State: Equatable {
        case createNew
        case edit(model: TaskModel)
    }

    var model: TaskEditModel

    let state: State

    init(state: State) {
        switch state {
        case .createNew:
            model = .init(syncStatus: .pending)
        case .edit(let arg):
            model = .init(task: arg)
        }

        self.state = state
    }

    func create(
        storage: any PersistentRepositoryProtocol<TaskEntity, TaskModel>,
        taskSource: TaskSourceViewModel
    ) async {
        let task = model.toTask()
        do {
            try await storage.insert(task)
            taskSource.tasks.append(task)
        } catch {
            Logger.app.warning("Couldn't create a new task")
        }
    }
}

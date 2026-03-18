import Foundation
import SwiftUI

@Observable
class TaskEditViewModel {
    enum State {
        case createNew
        case edit(model: TaskModel)
    }

    var model: TaskEditModel

    init(state: State) {
        switch state {
        case .createNew:
            model = .init()
        case .edit(let arg):
            model = .init(task: arg)
        }
    }
}

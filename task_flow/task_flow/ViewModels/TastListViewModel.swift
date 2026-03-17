import Combine
import Foundation
import SwiftData
import SwiftUI
import os

@Observable
final class TaskListViewModel {
    var selectedFilterItem: String = "1" {
        didSet {
            onSelectedFilterChanged.send(selectedFilterItem)
        }
    }

    var filteredList: [TaskModel] = []
    var isLoading = true

    private var cancellables = Set<AnyCancellable>()
    private var originList: [TaskModel] = [] {
        didSet {
            filteredList = originList
        }
    }
    private var onSelectedFilterChanged = CurrentValueSubject<String, Never>("")

    init() {
        onSelectedFilterChanged.debounce(for: 2, scheduler: RunLoop.main)
            .sink { [unowned self] item in
                self.handleFilterChanged(value: item)
            }
            .store(in: &cancellables)
    }

    func onAppear(storage: any PersistentRepositoryProtocol<TaskEntity, TaskModel>) async {
        do {
            // let result = try await storage.fetchAll()
            // originList = result.map { .map(from: $0) }
        } catch {
            Logger.app.error("Couldn't fetch all data. Error: \(error)")
        }
    }

    private func handleFilterChanged(value: String) {
        filteredList = originList.filter { item in
            item.title.contains(value)
        }
    }
}

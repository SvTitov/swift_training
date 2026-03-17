import Combine
import Foundation
import SwiftData
import SwiftUI
import os

@Observable
final class TaskListViewModel {
    // MARK: Public
    var selectedFilterItem: String = "1" {
        didSet {
            onSelectedFilterChanged.send(selectedFilterItem)
        }
    }
    var filteredList: [TaskModel] = []
    var isLoading = true

    // MARK: Private
    private var cancellables = Set<AnyCancellable>()
    private var onSelectedFilterChanged = CurrentValueSubject<String, Never>("")
    private let domain = TaskListDomain()
    private var originList: [TaskModel] = [] {
        didSet {
            filteredList = originList
        }
    }
    private var bgService: BackgroundService?

    init() {
        onSelectedFilterChanged.debounce(for: 2, scheduler: RunLoop.main)
            .sink { [unowned self] item in
                self.handleFilterChanged(value: item)
            }
            .store(in: &cancellables)
    }

    func onAppear(
        storage: any PersistentRepositoryProtocol<TaskEntity, TaskModel>, network: NetworkRepository
    ) async {
        do {
            let result = try await domain.fetchTasks(repo: storage, remote: network)
            originList = result

            if bgService == nil {
                bgService = BackgroundService(
                    syncService: SyncService(storage: storage, network: network))
            }

        } catch {
            Logger.app.error("Couldn't fetch all data. Error: \(error)")
        }
    }

    private func handleFilterChanged(value: String) {
        filteredList = originList.filter { item in
            item.title.contains(value)
        }
    }

    func prepareBackground() {
        self.bgService?.pepare()
    }

    func runBackground() async {
        await self.bgService?.run()
    }
}

import Combine
import Foundation
import SwiftData
import SwiftUI
import os

@Observable
final class TaskListViewModel {
    // MARK: Public
    var selectedFilterItem: SyncStatus = .any {
        didSet {
            onSelectedFilterChanged.send(selectedFilterItem)
        }
    }
    var filteredList: [TaskModel] = []
    var isLoading = true
    weak var taskSource: TaskSourceViewModel?

    // MARK: Private
    private var cancellables = Set<AnyCancellable>()
    private var onSelectedFilterChanged = CurrentValueSubject<SyncStatus, Never>(.any)
    private let domain = TaskListDomain()
    private var bgService: BackgroundService?

    init() {
        onSelectedFilterChanged.debounce(for: 0.4, scheduler: RunLoop.main)
            .sink { [unowned self] item in
                self.handleFilterChanged(value: item)
            }
            .store(in: &cancellables)
    }

    func onAppear(
        storage: any PersistentRepositoryProtocol<TaskEntity, TaskModel>, network: NetworkRepository
    ) async {
        if bgService == nil {
            bgService = BackgroundService(
                syncService: SyncService(storage: storage, network: network))
        }

        await refresh(storage, network)
    }

    func refresh(
        _ storage: any PersistentRepositoryProtocol<TaskEntity, TaskModel>,
        _ network: NetworkRepository
    ) async {
        do {
            isLoading = true
            defer {
                isLoading = false
            }

            async let fetching = domain.fetchTasks(repo: storage, remote: network)
            async let syncTasks: () = domain.syncTasks(repo: storage, network: network)

            let (tasks, _) = await (try? fetching, syncTasks)

            if let tasks, let taskSource {
                taskSource.tasks = tasks
                filteredList = tasks
            }
        } catch {
            Logger.app.error("Couldn't fetch all data. Error: \(error)")
        }
    }

    func prepareBackground() {
        self.bgService?.pepare()
    }

    func runBackground() async {
        await self.bgService?.run()
    }

    private func handleFilterChanged(value: SyncStatus) {
        guard let taskSource else { return }

        filteredList = taskSource.tasks.filter { item in
            if value == .any {
                true
            } else {
                item.syncStatus == value
            }
        }
    }
}

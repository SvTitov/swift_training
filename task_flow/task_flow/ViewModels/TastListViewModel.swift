import Combine
import Foundation
import SwiftData
import SwiftUI
import os

class TaskListViewModel: ObservableObject {
    @Published var selectedFilterItem: String = "1"
    @Published var filteredList: [TaskModel] = []
    @Published var isLoading = true

    private var cancellables = Set<AnyCancellable>()
    private var originList: [TaskModel] = [] {
        didSet {
            filteredList = originList
        }
    }

    init() {
        $selectedFilterItem.throttle(for: 2, scheduler: RunLoop.main, latest: true)
            .sink { [unowned self] item in
                self.handleFilterChanged(value: item)
            }
            .store(in: &cancellables)
    }

    func onAppear<Repo: PersistentRepositoryProtocol>(storage: Repo) async
    where Repo.Entity == TaskEntity {
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

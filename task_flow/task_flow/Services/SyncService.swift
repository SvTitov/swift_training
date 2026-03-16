import Foundation

public actor SyncService {
    enum State { case stopped, running, needRetry, retrying, done }

    var state: State = .stopped

    var storage: PersistentRepository<TaskEntity, TaskModel>
    var network: NetworkRepository
    var runningTask: Task<(), Never>?

    init(storage: PersistentRepository<TaskEntity, TaskModel>, network: NetworkRepository) {
        self.storage = storage
        self.network = network
    }

    public func start() {
        runningTask = Task.detached { [weak self] in
            guard let self = self else {
                return
            }

            /* *
             *               Sync service
             *
             * Send all local tasks till the state changed to done
             *
             * */
            var state: State = await self.state
            while state != .done && state != .stopped {
                do {
                    try Task.checkCancellation()
                } catch {
                    return
                }

                try? await self.innerRunning()
                try? await Task.sleep(for: .seconds(5))

                state = await self.state
            }
        }
    }

    public func stop() {
        runningTask?.cancel()
        changeState(.stopped)
    }

    private func innerRunning() async throws {
        self.changeState(.running)

        let allowedStatuse = [SyncStatus.pending.rawValue, SyncStatus.conflict.rawValue]
        let items = try await self.storage.fetch(
            predicate: #Predicate<TaskEntity> { item in
                allowedStatuse.contains(item.syncStatus.rawValue)
            })

        for var item in items {
            switch item.syncStatus {
            case .pending:
                // If it's needed to be sync
                let (code, _) = try await self.network.post(
                    TaskResponseDto.self, resource: "", body: TaskDto.stub())

                if code == 200 {
                    item.syncStatus = .synced
                } else {
                    self.changeState(.needRetry)
                }
            case .conflict:
                print("")
            default:
                print("Nothing")
            }
        }

        let isSynced = items.allSatisfy { $0.syncStatus == .synced }
        if isSynced { changeState(.done) }

        try? await self.storage.commit()
    }

    func changeState(_ state: State) {
        if self.state != state {
            self.state = state
        }
    }
}

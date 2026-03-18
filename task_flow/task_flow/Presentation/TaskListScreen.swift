import Foundation
import SwiftData
import SwiftUI

struct TaskListScreen: View {
    @State private var viewModel = TaskListViewModel()

    @State var storage: (any PersistentRepositoryProtocol<TaskEntity, TaskModel>)?
    @EnvironmentObject var navigator: Navigator

    @Environment(\.modelContext) private var modelContext
    @Environment(\.network) private var network
    @Environment(\.scenePhase) private var scenePhase
    @Environment(TaskSourceViewModel.self) var taskSource

    var body: some View {
        VStack {
            VStack {
                Picker("Filter", selection: $viewModel.selectedFilterItem) {
                    ForEach(
                        [
                            SyncStatus.any, SyncStatus.pending, SyncStatus.synced,
                            SyncStatus.conflict,
                        ],
                        id: \.self
                    ) { item in
                        Text(item.rawValue.description).tag(item)
                    }
                }
                .pickerStyle(.automatic)
                .labelsVisibility(.visible)
            }
            .frame(maxWidth: .infinity, alignment: .top)
            .background(Color(UIColor.lightGray).opacity(0.4))

            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            } else {
                List(viewModel.filteredList) { item in
                    HStack {
                        Text(item.title)

                        Spacer()

                        switch item.syncStatus {
                        case .conflict: Text("⚠️")
                        case .pending: Text("⏳")
                        case .synced: Text("✅")
                        case .any: EmptyView()
                        }

                    }
                    .onTapGesture {
                        navigator.push(.edit(item))
                    }
                }
                .listStyle(.inset)
                .refreshable {
                    guard let storage else { return }
                    await viewModel.refresh(storage, network)
                }
            }
        }
        .navigationTitle("Task List")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Create") {
                    navigator.push(.create)
                }
            }
        }
        .task {
            if storage == nil {
                storage = PersistentRepository<TaskEntity, TaskModel>(
                    modelContainer: modelContext.container)
            }
            guard let storage else { return }

            viewModel.taskSource = taskSource
            await viewModel.onAppear(storage: storage, network: network)
            viewModel.prepareBackground()
        }
        .onChange(of: scenePhase) {
            if scenePhase == .background {
                Task { await viewModel.runBackground() }
            }
        }
    }
}

#Preview {
    NavigationView {
        TaskListScreen(storage: PersistentRepositoryMock<TaskEntity, TaskModel>())
    }
}

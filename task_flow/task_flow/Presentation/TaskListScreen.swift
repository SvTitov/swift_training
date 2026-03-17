import Foundation
import SwiftData
import SwiftUI

struct TaskListScreen: View {
    let testSource = ["all", "1", "2", "3"]
    @State private var selectedItem: String = "Filter"
    @Bindable private var viewModel = TaskListViewModel()

    @State var storage: (any PersistentRepositoryProtocol<TaskEntity, TaskModel>)?
    @Environment(\.modelContext) private var modelContext
    @Environment(\.network) private var network
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        VStack {
            VStack {
                Picker("Filter", selection: $viewModel.selectedFilterItem) {
                    ForEach(testSource, id: \.self) { item in
                        Text(item)
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
                    }
                    .listRowSeparator(.hidden)
                }
                .listStyle(.inset)
            }
        }
        .task {
            if storage == nil {
                storage = PersistentRepository<TaskEntity, TaskModel>(
                    modelContainer: modelContext.container)
            }
            guard let storage else { return }

            await viewModel.onAppear(storage: storage, network: network)
            viewModel.prepareBackground()
        }
        .onChange(of: scenePhase) {
            switch scenePhase {
            case .background:
                Task { await viewModel.runBackground() }
            default:
                break
            }
        }
    }
}

#Preview {
    TaskListScreen(storage: PersistentRepositoryMock<TaskEntity, TaskModel>())
}

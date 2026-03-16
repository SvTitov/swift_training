import Foundation
import SwiftData
import SwiftUI

struct TaskListScreen: View {

    let testSource = ["all", "1", "2", "3"]
    @State var selectedItem: String = "Filter"
    @StateObject var viewModel = TaskListViewModel()

    @State var storage: PersistentRepository<TaskEntity, TaskModel>?

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
        .onAppear {
            if storage == nil {
                // storage = PersistentRepository<TaskEntity>(modelContainer: modelContext.
            }
            Task { await viewModel.onAppear(storage: storage!) }
        }
    }
}

#Preview {
    TaskListScreen()
}

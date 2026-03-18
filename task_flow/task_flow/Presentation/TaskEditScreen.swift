import Foundation
import SwiftUI

struct TaskEditScreen: View {
    @State var viewModel: TaskEditViewModel
    @State var storage: (any PersistentRepositoryProtocol<TaskEntity, TaskModel>)?
    
    @Environment(\.modelContext) private var modelContext
    @Environment(TaskSourceViewModel.self) var taskSource
    @EnvironmentObject var navigator: Navigator

    var body: some View {
        Form {
            editView
            dateView
            syncStatusView
        }
        .navigationTitle("Edit task")
        .toolbar {
            if viewModel.state == TaskEditViewModel.State.createNew {
                ToolbarItem(placement: .primaryAction) {
                    Button("Done") {
                        Task {
                            guard let storage else { return }
                            await viewModel.create(storage: storage, taskSource: taskSource)
                            navigator.pop()
                        }
                    }
                }
            }
        }
        .task {
            if storage == nil {
                storage = PersistentRepository<TaskEntity, TaskModel>(
                    modelContainer: modelContext.container)
            }
        }
    }

    private var editView: some View {
        Section("Main") {
            TextField("Title", text: $viewModel.model.title)
                .textInputAutocapitalization(.sentences)

            Toggle("Done", isOn: $viewModel.model.isCompleted)

            Picker("Priority", selection: $viewModel.model.priority) {
                Text("Low").tag(Priority.low)
                Text("Medium").tag(Priority.medium)
                Text("High").tag(Priority.high)
            }
            .pickerStyle(.segmented)
        }
    }

    private var dateView: some View {
        Section("Dates") {
            LabeledContent(
                "CreatedAt",
                value: viewModel.model.createdAt.formatted(date: .abbreviated, time: .shortened))
            LabeledContent(
                "UpdatedAt",
                value: viewModel.model.updatedAt.formatted(date: .abbreviated, time: .shortened))
        }
    }

    private var syncStatusView: some View {
        HStack {
            switch viewModel.model.syncStatus {
            case .pending:
                Image(systemName: "icloud.and.arrow.up")
                    .foregroundColor(.orange)
                Text("Pending")
                    .font(.caption)
            case .synced:
                Image(systemName: "checkmark.icloud")
                    .foregroundColor(.green)
                Text("Synced")
                    .font(.caption)
            case .conflict:
                Image(systemName: "exclamationmark.icloud")
                    .foregroundColor(.red)
                Text("Conflict")
                    .font(.caption)
            case .any:
                EmptyView()
            }
        }
    }
}

#Preview {
    let sampleTask = TaskModel.init(
        title: "Buy goods",
        remoteId: 42,
        syncStatus: .synced,
        isCompleted: false,
        createdAt: .now,
        priority: .medium,
        updateAt: .now
    )

    NavigationStack {
        TaskEditScreen(viewModel: TaskEditViewModel(state: .createNew))
    }
}

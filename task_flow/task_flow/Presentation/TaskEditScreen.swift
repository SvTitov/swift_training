import Foundation
import SwiftUI

struct TaskEditScreen: View {
    @Bindable var viewModel: TaskEditViewModel

    var body: some View {
        Form {
            editView
            dateView
            syncStatusView
        }
        .navigationTitle("Edit task")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Done") {

                }
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

import SwiftUI

struct ChatScreen: View {
    @State var viewModel = ChatViewModel()

    var body: some View {
        VStack {
            ChatView(messages: viewModel.messages)
        }
        .toolbar {
            Button("Send message") {
                viewModel.sendTestMessage()
            }
        }
        .task {
            await viewModel.startChat()
        }
    }
}

#Preview {
    NavigationStack {
        ChatView(messages: [])
    }
}

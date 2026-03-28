import SwiftUI

struct ChatView: View {
    var messages: [MessageModel]

    var body: some View {
        List {
            ForEach(messages, id: \.id) { value in
                createCell(text: value.message, isIncoming: value.messageType == .income)
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
    }

    @ViewBuilder
    func createCell(text: String, isIncoming: Bool = true) -> some View {
        HStack {
            if isIncoming == false {
                Spacer()
            }

            Text(text)
                .lineLimit(0)
                .frame(minWidth: 50)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(isIncoming ? .blue : .green)
                )

            if isIncoming {
                Spacer()
            }
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ChatView(messages: [])
}

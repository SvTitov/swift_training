import Combine
import SwiftUI

@Observable
final class ChatViewModel {
    var messages: [MessageModel] = []

    private var domain = ChatDomain()
    private var (outStream, outContinuation) = AsyncStream<MessageModel>.makeStream()
    private var incomingStream: AsyncThrowingStream<MessageModel, Error>?
    private var incomeProccesingTask: Task<(), Never>?

    @MainActor
    func startChat() async {
        do {
            incomingStream = try await domain.establishConnection(outgoing: outStream)

            incomeProccesingTask = Task(priority: .high) { [weak self] in
                guard let self else { return }
                guard let income = self.incomingStream else { return }

                do {
                    for try await message in income {
                        self.messages.append(message)
                    }
                } catch {
                    print("Error while receiving messages: \(error)")
                }

            }
        } catch {
            print("Error while establishing the connection: \(error)")
        }
    }

    func stopChat() async {
        self.incomeProccesingTask?.cancel()
        self.incomingStream = nil
    }

    func sendTestMessage() {
        let model = MessageModel(
            id: UUID(),
            message: "Hello there",
            messageType: .outcome
        )
        self.messages.append(model)

        self.outContinuation.yield(model)
    }
}

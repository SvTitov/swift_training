import Foundation

struct MessageModel: Identifiable {
    enum MessageType {
        case income, outcome
    }

    var id: UUID
    var message: String
    var messageType: MessageType
}

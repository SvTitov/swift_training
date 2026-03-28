struct ChatDomain {
    let network: GRPCNetwork = .shared

    func establishConnection(outgoing: AsyncStream<MessageModel>) async throws
        -> AsyncThrowingStream<
            MessageModel, Error
        >
    {
        try await network.establishBidirectionalChat(messages: outgoing)
    }
}

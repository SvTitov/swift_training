import Combine
import Foundation
import GRPCCore
import GRPCNIOTransportHTTP2
import GRPCProtobuf

struct LogginingInterceptor: ClientInterceptor {
    func intercept<Input, Output>(
        request: GRPCCore.StreamingClientRequest<Input>, context: GRPCCore.ClientContext,
        next: (GRPCCore.StreamingClientRequest<Input>, GRPCCore.ClientContext) async throws ->
            GRPCCore.StreamingClientResponse<Output>
    ) async throws -> GRPCCore.StreamingClientResponse<Output>
    where Input: Sendable, Output: Sendable {
        print("--- Calling RPC method: \(context.descriptor.method)")
        return try await next(request, context)
    }
}

class GRPCNetwork {
    static var shared: GRPCNetwork = GRPCNetwork()

    enum GRPCNetworkError: Error {
        case sendingError
    }

    private var connectionTask: Task<Void, Never>?
    private var grpcClient: GRPCClient<HTTP2ClientTransport.Posix>?
    private var loginClient: (any Login_Login.ClientProtocol)?
    private var chatClient: (any Chat_Chat.ClientProtocol)?
    private lazy var interceptors: [any ClientInterceptor] = {
        [LogginingInterceptor()]
    }()

    func connect(host: String, port: Int) async throws {
        let client: GRPCClient<HTTP2ClientTransport.Posix> = GRPCClient(
            transport: try .http2NIOPosix(
                target: .dns(host: "localhost", port: 50051),
                transportSecurity: .plaintext),
            interceptors: interceptors
        )

        self.grpcClient = client

        connectionTask = Task.detached {
            do {
                try await client.runConnections()
            } catch {
                print("Error while running the connection")
            }
        }

        self.loginClient = Login_Login.Client(wrapping: client)
        self.chatClient = Chat_Chat.Client(wrapping: client)
    }

    func stop() {
        self.grpcClient?.beginGracefulShutdown()
        connectionTask?.cancel()

        self.grpcClient = nil
        self.connectionTask = nil
        self.loginClient = nil
    }

    func authentication(login: String, password: String) async throws
        -> Login_AuthenticationResponse
    {
        // Another way connect to server
        //
        // let transport = try HTTP2ClientTransport.Posix(
        //     target: .dns(host: "localhost", port: 50051),
        //     transportSecurity: .plaintext
        // )
        //
        // try await withGRPCClient(transport: transport) { client in
        //     let login = Login_Login.Client(wrapping: client)
        //
        //     let message = Login_AuthenticationRequest.with {
        //         $0.login = "admin"
        //         $0.password = "123"
        //     }
        //
        //     try await login.authentication(request: ClientRequest(message: message)) { response in
        //         let message = try response.message
        //         print("Get token: \(message.token)")
        //     }
        // }
        //

        let message = Login_AuthenticationRequest.with {
            $0.login = login
            $0.password = password
        }

        let request = GRPCCore.ClientRequest(message: message)
        guard let loginClient = self.loginClient else { throw GRPCNetworkError.sendingError }

        return try await loginClient.authentication(request: request)
    }

    func establishBidirectionalChat(messages: AsyncStream<MessageModel>) async throws
        -> AsyncThrowingStream<MessageModel, Error>
    {
        AsyncThrowingStream<MessageModel, Error> { continuation in
            Task {
                let metadata = Metadata([
                    "authorization": "Bearer \(UserData.token ?? "")"
                ])

                try await chatClient?.chatStream(metadata: metadata) { writer in
                    for await message in messages {
                        print("Going to send message: \(message.message)")
                        try await writer.write(.with { $0.message = message.message })
                    }
                } onResponse: { response in
                    for try await chatMessage in response.messages {
                        print("Received message: \(chatMessage.message)")
                        continuation.yield(
                            MessageModel(
                                id: UUID(),
                                message: chatMessage.message,
                                messageType: .income
                            )
                        )
                    }

                    continuation.finish()
                }
            }
        }
    }
}

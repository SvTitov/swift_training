import Testing

@testable import gRPC_Chat

struct gRPC_ChatTests {
    @Test func shouldEstablishDuplexConnectionAndEchoMessages () async throws {
        // Arrange
        let network = GRPCNetwork()
        try await network.connect(host: "localhost", port: 50051)
        let (stream, continuation) = AsyncStream<String>.makeStream()
        
        // Act
        async let sending = Task {
            var outputArray : [String] = []
            var counter = 0
            while counter < 5 {
                let message = "message \(counter)"
                continuation.yield(message)
                outputArray.append(message)
                counter += 1
            }
            
            continuation.finish()
            
            return outputArray
        }
        
        async let receiving = Task {
            var inputArray : [String] = []
            for try await item in try await network.send3(messages: stream) {
                inputArray.append(item)
                if inputArray.count >= 5 { break }
            }
            
            return inputArray
        }
        
        let outputArray = await sending.value
        let inputArray = try await receiving.value
        
        // Assert
        assert(outputArray == inputArray)
    }
}

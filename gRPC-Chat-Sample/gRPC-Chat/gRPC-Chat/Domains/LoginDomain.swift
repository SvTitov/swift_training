struct LoginDomain {
    let network: GRPCNetwork = .shared

    func confirm(login: String, password: String) async throws {
        try await network.connect(host: "localhost", port: 50051)
        let result = try await network.authentication(login: login, password: password)
        UserData.token = result.token
    }
}

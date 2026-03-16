import SwiftUICore

private struct UserServiceKey: EnvironmentKey {
    static let defaultValue: UserServiceProtocol? = nil
}

extension EnvironmentValues {
    var userService: UserServiceProtocol? {
        get { self[UserServiceKey.self] }
        set { self[UserServiceKey.self] = newValue }
    }
}

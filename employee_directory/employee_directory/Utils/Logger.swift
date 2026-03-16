import os
import Foundation

extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier!
    static let network = Logger(subsystem: subsystem, category: "network")
    static let app = Logger(subsystem: subsystem, category: "app_flow")
}

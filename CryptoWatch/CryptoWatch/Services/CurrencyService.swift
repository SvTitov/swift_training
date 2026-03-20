import Foundation

actor CurrencyService {
    private enum Endpoints: String {
        case baseUrl = "http://api.coingecko.com/api/v3"
        case current =
            "/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=50&page=1&sparkline=false"
    }

    enum ServiceError: Error {
        case userDataIssue
    }

    private var inMemoryCache: [String: CacheData] = [:]

    let networkRepository = NetworkRepository()

    func retriveMarkets() async throws -> [MarketDto] {
        let cacheKey = "markets"

        let cacheValue =
            inMemoryCache[cacheKey]
            ?? {
                let data = CacheData()
                inMemoryCache[cacheKey] = data
                return data
            }()

        // If data older than 30 min then refresh
        let threshold = Date().addingTimeInterval(-30 * 60)

        if cacheValue.updateAt < threshold {
            // Need refresh
            let (statusCode, markets) = try await networkRepository.get(
                [MarketDto].self,
                resource: Endpoints.baseUrl.rawValue + Endpoints.current.rawValue)

            guard statusCode == 200 else { throw ServiceError.userDataIssue }

            cacheValue.refreshData(data: markets)
        }

        //TODO: throw error if you have parsing issue
        return cacheValue.data as? [MarketDto] ?? []
    }
}

private class CacheData {
    var updateAt: Date
    var data: Any?

    init(updateAt: Date = Date(timeIntervalSince1970: 0), data: Any? = nil) {
        self.updateAt = updateAt
        self.data = data
    }

    func refreshUpdateTime() {
        updateAt = .now
    }

    func refreshData(data: Any) {
        self.data = data
    }
}

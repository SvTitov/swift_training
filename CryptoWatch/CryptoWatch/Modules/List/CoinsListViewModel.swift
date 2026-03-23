import Foundation

class CoinsListViewModel {
    private let currencyService = CurrencyService()

    @Published private(set) var coinModels: [MarketModel] = []

    func fetch() async throws {
        let result = try await currencyService.retriveMarkets()
        coinModels = result.map { .init(from: $0) }
    }
}

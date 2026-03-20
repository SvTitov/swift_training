import Testing

@testable import CryptoWatch

struct CryptoWatchTests {

    @Test func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    }

    @Test func shouldGet200AndReturnValidArray() async throws {
        // Arrange
        let coinService = CurrencyService()
        
        // Act
        let result = try await coinService.retriveMarkets()
        
        // Assert
        #expect(result.isEmpty == false)
    }
}

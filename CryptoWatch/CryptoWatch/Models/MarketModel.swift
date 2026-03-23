struct MarketModel {
    var name: String = ""
    var symbol: String = ""
    var icon: String = ""
    var price: Double = 0.0
    var priceChange24H: Double = 0.0

    init(from: MarketDto) {
        name = from.name ?? ""
        symbol = from.symbol ?? ""
        icon = from.image ?? ""
        price = from.currentPrice ?? 0
        priceChange24H = from.priceChange24H ?? 0.0
    }
}

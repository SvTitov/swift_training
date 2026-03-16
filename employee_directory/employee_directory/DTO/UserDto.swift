import Foundation

// MARK: - WelcomeElement
struct UserDto: Codable {
    let id: Int
    let name, username, email: String
    let address: AddressDto
    let phone, website: String
    let company: CompanyDto
}

// MARK: - Address
struct AddressDto: Codable {
    let street, suite, city, zipcode: String
    let geo: GeoDto
}

// MARK: - Geo
struct GeoDto: Codable {
    let lat, lng: String
}

// MARK: - Company
struct CompanyDto: Codable {
    let name, catchPhrase, bs: String
}

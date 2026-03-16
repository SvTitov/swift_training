import Foundation
struct UserModel: Identifiable, Hashable {
    let id: UUID
    let name, email, city: String
    let phone, website, companyName: String
}

extension UserModel {
    static func map(from: UserDto) -> Self {
        UserModel(
            id: UUID(),
            name: from.name,
            email: from.email,
            city: from.address.city,
            phone: from.phone,
            website: from.website,
            companyName: from.company.name,
        )
    }
}

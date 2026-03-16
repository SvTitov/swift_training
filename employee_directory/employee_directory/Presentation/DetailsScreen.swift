import SwiftUI

struct DetailsScreen: View {
    
    let model: UserModel
    
    var body: some View {
        VStack {
            InfoInRow(title: "Name", value: model.name)
            InfoInRow(title: "Email", value: model.email)
            InfoInRow(title: "City", value: model.city)
            InfoInRow(title: "Phone", value: model.phone)
            InfoInRow(title: "Website", value: model.website)
            InfoInRow(title: "Company", value: model.companyName)
            
            Spacer()
        }
        .padding()
    }
}

struct InfoInRow: View {
    var title: String
    var value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
            Spacer()
            Text(value)
        }
        .padding()
    }
}

#Preview {
    DetailsScreen(model: UserModel(id: .init(), name: "TestName", email: "", city: "", phone: "", website: "", companyName: ""))
}

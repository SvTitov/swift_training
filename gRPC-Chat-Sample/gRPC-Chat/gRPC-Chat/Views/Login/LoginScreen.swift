import SwiftUI

struct LoginScreen: View {
    @EnvironmentObject var navigator: Navigator
    @State var viewModel = LoginViewModel()

    var body: some View {
        VStack {
            TextField("Login", text: $viewModel.login)
                .textContentType(.name)
            SecureField("Password", text: $viewModel.password)
            
            Text("admin\t123")
            
            Button("Confirm") {
                Task {
                    await viewModel.confirm(nav: navigator)
                }
            }
            .padding(.top, 10)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.gray.opacity(0.4))
        )
        .padding(20)
        .alert("Error", isPresented: $viewModel.alertViewModel.isShown) {
            Text(viewModel.alertViewModel.text)
        }
      
    }
}

#Preview {
    LoginScreen()
}

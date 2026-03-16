import SwiftUI

struct ListScreen: View {
    @Environment(\.userService) var userService
    @EnvironmentObject var navigator: Navigator
    @EnvironmentObject var favoriteService: FavoritesService
    @StateObject private var vm = ListScreenViewModel()
    @State private var search: String = ""
    
    var searchResult: [UserModel] {
        if search.isEmpty {
            return vm.users
        } else {
            return vm.users.filter { $0.name.localizedCaseInsensitiveContains(search) }
        }
    }
    
    var body: some View {
        List {
            ForEach(searchResult, id: \.id) { user in
                VStack {
                    HStack{
                        Text(user.name)
                        Spacer()
                        Text(user.email)
                        Image(systemName: "heart.fill")
                            .foregroundStyle(favoriteService.isFavorite(user.name) ? .red : .blue)
                            .onTapGesture {
                                vm.markAsFavorite(model: user, favoriteService: favoriteService)
                            }
                    }
                    
                    HStack{
                        Text(user.city)
                        Spacer()
                    }
                }
                .font(.system(size: 12))
                .listRowBackground(
                    Color.gray.opacity(0.3)
                        .cornerRadius(10)
                        .padding(.vertical, 8)
                )
                .listRowSeparator(.hidden)
                .padding()
                .onTapGesture {
                    vm.openDetails(id: user, navigator: navigator)
                }
            }
        }
        .padding()
        .listStyle(.inset)
        .refreshable {
            guard let userService else { return }
            await vm.refresh(userService, favoriteService)
        }
        .onAppear {
            Task {
                guard let userService else { return }
                await vm.refresh(userService, favoriteService)
            }
        }
        .searchable(text: $search)
        .alert("Warning!", isPresented: $vm.showAlert) {
            Text(vm.errorMessage)
            Button("OK") {
                vm.showAlert = false
            }
        }
    }
}

#Preview {
    ListScreen()
}

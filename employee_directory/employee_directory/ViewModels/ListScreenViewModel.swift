import Foundation
import os

@MainActor
class ListScreenViewModel: ObservableObject {
    @Published var users: [UserModel] = []
    @Published var showAlert: Bool = false
   
    var errorMessage: String = ""
    
    func refresh(_ userService: UserServiceProtocol,_ favoriteService: FavoritesService) async {
        do {
            let result = try await userService.fetch()
            
            Logger.app.info(">>> We receive models from network")
            
            let users = result.map { user in
                var modifided = user
                // TODO: model name is bad practice, use uniq key
                return modifided
            }
            
            self.users = users
        } catch {
            errorMessage = error.localizedDescription
            showAlert = true
        }
    }
    
    func openDetails<Nav: NavigatorProtocol>(id: UserModel, navigator: Nav) {
        navigator.push(.details(id))
    }
    
    func markAsFavorite(model: UserModel, favoriteService: FavoritesService) {
        //TODO: model name is bad change to uniq id
        favoriteService.toggle(model.name)
    }
}

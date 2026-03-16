import Foundation

final class FavoritesService: ObservableObject {
    @Published private(set) var favoriteIds: Set<String> = []
    
    private let userDefaults: UserDefaults
    private let favoritesKey = "favoriteIds"
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        load()
    }
    
    func add(_ id: String) {
        favoriteIds.insert(id)
        save()
    }
    
    func remove(_ id: String) {
        favoriteIds.remove(id)
        save()
    }
    
    func toggle(_ id: String) {
        if favoriteIds.contains(id) {
            remove(id)
        } else {
            add(id)
        }
    }
    
    func isFavorite(_ id: String) -> Bool {
        favoriteIds.contains(id)
    }
    
    private func load() {
        guard let data = userDefaults.data(forKey: favoritesKey),
              let ids = try? JSONDecoder().decode(Set<String>.self, from: data)
        else { return }
        favoriteIds = ids
    }
    
    private func save() {
        guard let data = try? JSONEncoder().encode(favoriteIds) else { return }
        userDefaults.set(data, forKey: favoritesKey)
    }
}

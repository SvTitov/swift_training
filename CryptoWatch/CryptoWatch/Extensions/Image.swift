import UIKit

extension UIImageView {
    static var imageCache = NSCache<NSString, UIImage>()

    func loadImage(urlString: String) {
        guard let url = URL(string: urlString) else { return }

        Task {
            do {
                let key = NSString(string: urlString)
                var imageCache = UIImageView.imageCache.object(forKey: key)

                if imageCache == nil {
                    let network = NetworkRepository()
                    let (data, _) = try await network.sharedSessions().data(from: url)
                    if let image = UIImage(data: data) {
                        UIImageView.imageCache.setObject(image, forKey: key)
                        imageCache = image
                    }
                }

                await MainActor.run {
                    self.image = imageCache
                }
            } catch {
                print("Received error: \(error)")
            }
        }
    }
}

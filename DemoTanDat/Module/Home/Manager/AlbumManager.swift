

import Foundation
import AVKit

class AlbumManager {
    static let shared = AlbumManager()

    typealias MediaItem = (thumbnail: UIImage, url: URL, isVideo: Bool, isFavorite: Bool)
    var mediaItems: [MediaItem] = []

    private init() {}

    // MARK: - Load & Save

    func loadMedia() {
        mediaItems.removeAll()
        let favoriteList = loadFavoritesList()

        let files = try? FileManager.default.contentsOfDirectory(at: getDocumentsDirectory(), includingPropertiesForKeys: nil)

        files?.forEach { file in
            let isFavorite = favoriteList.contains(file.lastPathComponent)

            if file.pathExtension == "jpg", let image = UIImage(contentsOfFile: file.path) {
                mediaItems.append((thumbnail: image, url: file, isVideo: false, isFavorite: isFavorite))
            } else if file.pathExtension == "mov" {
                let asset = AVAsset(url: file)
                let generator = AVAssetImageGenerator(asset: asset)
                if let cgImage = try? generator.copyCGImage(at: .zero, actualTime: nil) {
                    let thumbnail = UIImage(cgImage: cgImage)
                    mediaItems.append((thumbnail: thumbnail, url: file, isVideo: true, isFavorite: isFavorite))
                }
            }
        }
    }

    func saveImageToDisk(_ image: UIImage) -> URL? {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }
        let url = getDocumentsDirectory().appendingPathComponent(UUID().uuidString + ".jpg")
        do {
            try data.write(to: url)
            return url
        } catch {
            print("Error \(error)")
            return nil
        }
    }

    func saveVideoToDisk(_ originalURL: URL) -> URL? {
        let newURL = getDocumentsDirectory().appendingPathComponent(UUID().uuidString + ".mov")
        do {
            try FileManager.default.copyItem(at: originalURL, to: newURL)
            return newURL
        } catch {
            print("Error \(error)")
            return nil
        }
    }

    // MARK: - Favorites

    func addToFavorites(item: MediaItem) {
        let favoritesDir = getFavoritesDirectory()
        let destinationURL = favoritesDir.appendingPathComponent(item.url.lastPathComponent)

        do {
            if !FileManager.default.fileExists(atPath: destinationURL.path) {
                try FileManager.default.copyItem(at: item.url, to: destinationURL)
            }
            updateFavoriteStatus(for: item.url, isFavorite: true)
            
            NotificationCenter.default.post(name: Notification.Name("FavoritesUpdated"), object: nil)
        } catch {
            print("Error \(error)")
        }
    }

    func removeFromFavorites(item: MediaItem) {
        let favoritesDir = getFavoritesDirectory()
        let destinationURL = favoritesDir.appendingPathComponent(item.url.lastPathComponent)

        do {
            if FileManager.default.fileExists(atPath: destinationURL.path) {
                try FileManager.default.removeItem(at: destinationURL)
            }
            updateFavoriteStatus(for: item.url, isFavorite: false)
            NotificationCenter.default.post(name: Notification.Name("FavoritesUpdated"), object: nil)
        } catch {
            print("Error \(error)")
        }
    }

    func deleteItem(at index: Int) {
        let item = mediaItems[index]
        try? FileManager.default.removeItem(at: item.url)
        mediaItems.remove(at: index)
    }

    // MARK: - Helpers

    private func updateFavoriteStatus(for url: URL, isFavorite: Bool) {
        if let index = mediaItems.firstIndex(where: { $0.url == url }) {
            mediaItems[index].isFavorite = isFavorite
        }
        saveFavoritesList()
    }

    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    private func getFavoritesDirectory() -> URL {
        let url = getDocumentsDirectory().appendingPathComponent("Favorites")
        if !FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        }
        return url
    }

    private func saveFavoritesList() {
        let list = mediaItems.filter { $0.isFavorite }.map { $0.url.lastPathComponent }
        UserDefaults.standard.set(list, forKey: "favoriteFiles")
    }

    private func loadFavoritesList() -> Set<String> {
        let list = UserDefaults.standard.stringArray(forKey: "favoriteFiles") ?? []
        return Set(list)
    }
}

//
//  FavoriteManager.swift
//  DemoTanDat
//
//  Created by Đại Lợi Đẹp Trai on 26/4/25.
//

import Foundation

class FavoriteManager {
    static let shared = FavoriteManager()
    private let favoritesFile = "favorites.json"

    private var favorites: [String] = []

    private init() {
        loadFavorites()
    }

    private func favoritesURL() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(favoritesFile)
    }

    private func loadFavorites() {
        let url = favoritesURL()
        if let data = try? Data(contentsOf: url),
           let decoded = try? JSONDecoder().decode([String].self, from: data) {
            favorites = decoded
        }
    }

    private func saveFavorites() {
        let url = favoritesURL()
        if let data = try? JSONEncoder().encode(favorites) {
            try? data.write(to: url)
        }
    }

    func isFavorite(_ item: MediaItem) -> Bool {
        favorites.contains(item.fileName)
    }

    func addToFavorites(_ item: MediaItem) {
        if !favorites.contains(item.fileName) {
            favorites.append(item.fileName)
            saveFavorites()
        }
    }

    func removeFromFavorites(_ item: MediaItem) {
        if let index = favorites.firstIndex(of: item.fileName) {
            favorites.remove(at: index)
            saveFavorites()
        }
    }

    func getAllFavorites() -> [String] {
        favorites
    }
}

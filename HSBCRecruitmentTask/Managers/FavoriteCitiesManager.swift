//
//  FavoriteCitiesManager.swift
//  HSBCRecruitmentTask
//
//  Created by Krystian Paszek on 15/11/2020.
//

import Foundation

class FavoriteCitiesManager: CityFavoriting {

    static let kUserDefaultsFavoriteCitiesKey = "favorite_cities"

    // MARK: - Dependencies
    let userDefaults: UserDefaults

    // MARK: - Properties
    var favoriteCities: Set<UUID> {
        get {
            guard let savedData = userDefaults.object(forKey: Self.kUserDefaultsFavoriteCitiesKey) else {
                return Set<UUID>()
            }

            guard let readableData = savedData as? [String] else {
                assertionFailure("Saved data should be of [String] format")
                return Set<UUID>()
            }

            let uuids = readableData.compactMap { UUID(uuidString: $0) }
            let favoriteCities = Set(uuids)
            return favoriteCities
        }
        set {
            let savableData = Array(newValue).map { $0.uuidString }
            userDefaults.set(savableData, forKey: Self.kUserDefaultsFavoriteCitiesKey)
        }
    }

    // MARK: - Initialization
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }

}

// MARK: - CityFavoriting
extension FavoriteCitiesManager {
    func addToFavorites(id: UUID) {
        var currentFavorites = favoriteCities
        currentFavorites.insert(id)
        self.favoriteCities = currentFavorites
    }

    func removeFromFavorites(id: UUID) {
        var currentFavorites = favoriteCities
        currentFavorites.remove(id)
        self.favoriteCities = currentFavorites
    }

    func isCityFavorite(id: UUID) -> Bool {
        return favoriteCities.contains(id)
    }
}

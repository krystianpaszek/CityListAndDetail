//
//  FavoriteCitiesManager.swift
//  HSBCRecruitmentTask
//
//  Created by Krystian Paszek on 15/11/2020.
//

import Foundation

private let kUserDefaultsFavoriteCitiesKey = "favorite_cities"

class FavoriteCitiesManager: CityFavoriting {

    // MARK: - Dependencies
    let userDefaults: UserDefaults

    // MARK: - Properties
    var favoriteCities: Set<UUID> {
        get {
            guard let savedData = userDefaults.object(forKey: kUserDefaultsFavoriteCitiesKey) else {
                return Set<UUID>()
            }

            let cities = savedData as! Set<UUID>
            return cities
        }
        set {
            userDefaults.set(newValue, forKey: kUserDefaultsFavoriteCitiesKey)
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

    }

    func removeFromFavorites(id: UUID) {

    }

    func isCityFavorite(id: UUID) -> Bool {
        return false
    }
}

//
//  MockFavoriteCitiesManager.swift
//  CitiesListAndDetailTests
//
//  Created by Krystian Paszek on 15/11/2020.
//

@testable import CitiesListAndDetail
import Foundation

class MockFavoriteCitiesManager: CityFavoriting {

    // MARK: - Counters
    var addToFavoritesInvocationCount: Int = 0
    var removeFromFavoritesInvocationCount: Int = 0
    var isCityFavoriteInvocationCount: Int = 0

    // MARK: - Properties
    private var favoriteCities = Set<UUID>()

    // MARK: - CityFavoriting
    func addToFavorites(id: UUID) {
        addToFavoritesInvocationCount += 1
        favoriteCities.insert(id)
    }

    func removeFromFavorites(id: UUID) {
        removeFromFavoritesInvocationCount += 1
        favoriteCities.remove(id)
    }

    func isCityFavorite(id: UUID) -> Bool {
        isCityFavoriteInvocationCount += 1
        return favoriteCities.contains(id)
    }
}

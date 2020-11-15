//
//  MockFavoriteCitiesManager.swift
//  HSBCRecruitmentTaskTests
//
//  Created by Krystian Paszek on 15/11/2020.
//

@testable import HSBCRecruitmentTask
import Foundation

class MockFavoriteCitiesManager: CityFavoriting {

    // MARK: - Properties
    private var favoriteCities = Set<UUID>()

    // MARK: - CityFavoriting
    func addToFavorites(id: UUID) {
        favoriteCities.insert(id)
    }

    func removeFromFavorites(id: UUID) {
        favoriteCities.remove(id)
    }

    func isCityFavorite(id: UUID) -> Bool {
        favoriteCities.contains(id)
    }
}

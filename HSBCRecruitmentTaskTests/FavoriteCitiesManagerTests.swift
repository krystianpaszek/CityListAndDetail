//
//  FavoriteCitiesManagerTests.swift
//  HSBCRecruitmentTaskTests
//
//  Created by Krystian Paszek on 15/11/2020.
//

@testable import HSBCRecruitmentTask
import XCTest

private let kUserDefaultsDomainKey = "com.paszek.test." + #file

class FavoriteCitiesManagerTests: XCTestCase {

    // MARK: - Properties
    private var favoritesManager: CityFavoriting!
    private var userDefaults: UserDefaults!

    // MARK: - Setup
    override func setUpWithError() throws {
        userDefaults = UserDefaults(suiteName: kUserDefaultsDomainKey)
        userDefaults.removePersistentDomain(forName: kUserDefaultsDomainKey)
        favoritesManager = FavoriteCitiesManager(userDefaults: userDefaults)
    }

    // MARK: - Tests
    func testThatItPersistsFavoritedCityInTheUserDefaults() {
        // given
        let id = UUID()

        // when
        favoritesManager.addToFavorites(id: id)

        // then
        guard let data = userDefaults.object(forKey: FavoriteCitiesManager.kUserDefaultsFavoriteCitiesKey) else {
            XCTFail("saved data must be present")
            return
        }

        guard let favorites = data as? [String] else {
            XCTFail("favorites must be an array of Strings containing UUIDs")
            return
        }

        XCTAssertTrue(favorites.contains(id.uuidString))
    }

    func testThatItRemovesUnfavoritedCityFromTheUserDefaults() {
        // given
        let id = UUID()

        // when
        favoritesManager.addToFavorites(id: id)
        favoritesManager.removeFromFavorites(id: id)

        // then
        guard let data = userDefaults.object(forKey: FavoriteCitiesManager.kUserDefaultsFavoriteCitiesKey) else {
            XCTFail("saved data must be present")
            return
        }

        guard let favorites = data as? [String] else {
            XCTFail("favorites must be an array of Strings containing UUIDs")
            return
        }

        XCTAssertFalse(favorites.contains(id.uuidString))
    }

    func testThatYouCanRemoveNotFavoritedCities() {
        // given
        let id = UUID()

        // when
        favoritesManager.removeFromFavorites(id: id)

        // then
        XCTAssertFalse(favoritesManager.isCityFavorite(id: id))
    }

    func testThatItAddsFavoritedCity() {
        // given
        let id = UUID()

        // when
        favoritesManager.addToFavorites(id: id)

        // then
        XCTAssertTrue(favoritesManager.isCityFavorite(id: id))
    }

    func testThatItRemovesUnfavoritedCity() {
        // given
        let id = UUID()

        // when
        favoritesManager.addToFavorites(id: id)
        favoritesManager.removeFromFavorites(id: id)

        // then
        XCTAssertFalse(favoritesManager.isCityFavorite(id: id))
    }

    func testThatItDoesntAddSameCityMultipleTimes() {
        // given
        let id = UUID()

        // when
        favoritesManager.addToFavorites(id: id)
        favoritesManager.addToFavorites(id: id)
        favoritesManager.addToFavorites(id: id)
        favoritesManager.removeFromFavorites(id: id)

        // then
        XCTAssertFalse(favoritesManager.isCityFavorite(id: id))
    }

}

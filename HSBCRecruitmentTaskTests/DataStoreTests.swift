//
//  DataStoreTests.swift
//  HSBCRecruitmentTaskTests
//
//  Created by Krystian Paszek on 15/11/2020.
//

@testable import HSBCRecruitmentTask
import XCTest

class DataStoreTests: XCTestCase {

    private var dataStore: DataStoreProtocol!
    private var mockFavoriteCitiesManager: MockFavoriteCitiesManager!
    private var mockNetworkService: MockNetworkService!

    override func setUpWithError() throws {
        mockFavoriteCitiesManager = MockFavoriteCitiesManager()
        mockNetworkService = MockNetworkService()
        dataStore = DataStore(networkService: mockNetworkService, favoritesManager: mockFavoriteCitiesManager)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // test that it adds city to favorites
    // test that if removes city from favorites
    // test that it doesn't add city multiple times, so many adds -> one remove should be enough
    // test that it doesn't hit network once data was fetched from it
    // test that it hits network when asked to refresh

    func testThatItDoesntHitNetworkAfterInitialFetch() throws {
        // when
        dataStore.getCityList(reload: false, completion: { _, _ in } )
        dataStore.getCityList(reload: false, completion: { _, _ in } )
        dataStore.getCityList(reload: false, completion: { _, _ in } )

        // then
        XCTAssertEqual(mockNetworkService.fetchCityListInvocationCounter, 1)
    }

    func testThatItHitsNetworkWhenReloadingCities() throws {
        // when
        dataStore.getCityList(reload: true, completion: { _, _ in } )
        dataStore.getCityList(reload: false, completion: { _, _ in } )
        dataStore.getCityList(reload: true, completion: { _, _ in } )
        dataStore.getCityList(reload: false, completion: { _, _ in } )
        dataStore.getCityList(reload: true, completion: { _, _ in } )
        dataStore.getCityList(reload: false, completion: { _, _ in } )

        // then
        XCTAssertEqual(mockNetworkService.fetchCityListInvocationCounter, 3)
    }

    func testThatItHitsNetworkWhenReloadingCityRating() throws {
        // given
        let id = UUID()

        // when
        dataStore.getCityRating(reload: true, id: id, completion:  { _, _ in } )
        dataStore.getCityRating(reload: false, id: id, completion:  { _, _ in } )
        dataStore.getCityRating(reload: true, id: id, completion:  { _, _ in } )
        dataStore.getCityRating(reload: false, id: id, completion:  { _, _ in } )
        dataStore.getCityRating(reload: true, id: id, completion:  { _, _ in } )
        dataStore.getCityRating(reload: false, id: id, completion:  { _, _ in } )

        // then
        XCTAssertEqual(mockNetworkService.fetchCityRatingInvocationCounter, 3)
    }

    func testThatItHitsNetworkWhenReloadingCityPopulation() throws {
        // given
        let id = UUID()

        // when
        dataStore.getCityPopulation(reload: true, id: id, completion:  { _, _ in } )
        dataStore.getCityPopulation(reload: false, id: id, completion:  { _, _ in } )
        dataStore.getCityPopulation(reload: true, id: id, completion:  { _, _ in } )
        dataStore.getCityPopulation(reload: false, id: id, completion:  { _, _ in } )
        dataStore.getCityPopulation(reload: true, id: id, completion:  { _, _ in } )
        dataStore.getCityPopulation(reload: false, id: id, completion:  { _, _ in } )

        // then
        XCTAssertEqual(mockNetworkService.fetchCityPopulationInvocationCounter, 3)
    }

}

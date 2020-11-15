//
//  DataStoreTests.swift
//  HSBCRecruitmentTaskTests
//
//  Created by Krystian Paszek on 15/11/2020.
//

@testable import HSBCRecruitmentTask
import XCTest

private let kAsyncTimeout: TimeInterval = 1.0

class DataStoreTests: XCTestCase {

    // MARK: - Properties
    private var dataStore: DataStoreProtocol!
    private var mockFavoriteCitiesManager: MockFavoriteCitiesManager!
    private var mockNetworkService: MockNetworkService!

    // MARK: - Setup
    override func setUpWithError() throws {
        mockFavoriteCitiesManager = MockFavoriteCitiesManager()
        mockNetworkService = MockNetworkService()
        dataStore = DataStore(networkService: mockNetworkService, favoritesManager: mockFavoriteCitiesManager)
    }

    // test that it adds city to favorites
    // test that if removes city from favorites
    // test that it doesn't add city multiple times, so many adds -> one remove should be enough

    // MARK: - Tests
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
        let expectation = XCTestExpectation(description: "Load cities")

        // given
        let id = mockNetworkService.cityRating.id
        dataStore.getCityList(reload: false) { (_, _) in
            // when
            self.dataStore.getCityRating(reload: true, id: id, completion:  { _, _ in } )
            self.dataStore.getCityRating(reload: false, id: id, completion:  { _, _ in } )
            self.dataStore.getCityRating(reload: true, id: id, completion:  { _, _ in } )
            self.dataStore.getCityRating(reload: false, id: id, completion:  { _, _ in } )
            self.dataStore.getCityRating(reload: true, id: id, completion:  { _, _ in } )
            self.dataStore.getCityRating(reload: false, id: id, completion:  { _, _ in } )

            // then
            XCTAssertEqual(self.mockNetworkService.fetchCityRatingInvocationCounter, 3)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: kAsyncTimeout)
    }

    func testThatItHitsNetworkWhenReloadingCityPopulation() throws {
        let expectation = XCTestExpectation(description: "Load cities")

        // given
        let id = mockNetworkService.cityPopulation.id
        dataStore.getCityList(reload: false) { (_, _) in
            // when
            self.dataStore.getCityPopulation(reload: true, id: id, completion:  { _, _ in } )
            self.dataStore.getCityPopulation(reload: false, id: id, completion:  { _, _ in } )
            self.dataStore.getCityPopulation(reload: true, id: id, completion:  { _, _ in } )
            self.dataStore.getCityPopulation(reload: false, id: id, completion:  { _, _ in } )
            self.dataStore.getCityPopulation(reload: true, id: id, completion:  { _, _ in } )
            self.dataStore.getCityPopulation(reload: false, id: id, completion:  { _, _ in } )

            // then
            XCTAssertEqual(self.mockNetworkService.fetchCityPopulationInvocationCounter, 3)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: kAsyncTimeout)
    }

}

//
//  DataStoreTests.swift
//  CitiesListAndDetailTests
//
//  Created by Krystian Paszek on 15/11/2020.
//

@testable import CitiesListAndDetail
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

    func testThatItReturnsTheSameCities() {
        // given
        let expectation1 = XCTestExpectation(description: "Got first result")
        let expectation2 = XCTestExpectation(description: "Got second result")
        let expectation3 = XCTestExpectation(description: "Got third result")
        var result1, result2, result3: [City]?

        // when
        dataStore.getCityList(reload: false, completion: { cities, _ in
            result1 = cities
            expectation1.fulfill()
        })
        dataStore.getCityList(reload: false, completion: { cities, _ in
            result2 = cities
            expectation2.fulfill()
        })
        dataStore.getCityList(reload: false, completion: { cities, _ in
            result3 = cities
            expectation3.fulfill()
        })

        // then
        wait(for: [expectation1, expectation2, expectation3], timeout: kAsyncTimeout)
        XCTAssertEqual(result1, result2)
        XCTAssertEqual(result2, result3)
    }

    func testThatItReturnsPopulationForAGivenCity() {
        // given
        let id = mockNetworkService.cityPopulation.id
        let expectation = XCTestExpectation(description: "Got population")
        var result: CityPopulation?

        // when
        dataStore.getCityList(reload: false) { (_, _) in
            self.dataStore.getCityPopulation(reload: false, id: id) { (population, _) in
                result = population
                expectation.fulfill()
            }
        }

        // then
        wait(for: [expectation], timeout: kAsyncTimeout)
        XCTAssertEqual(result?.id, id)
    }

    func testThatItReturnsRatingForAGivenCity() {
        // given
        let id = mockNetworkService.cityRating.id
        let expectation = XCTestExpectation(description: "Got rating")
        var result: CityRating?

        // when
        dataStore.getCityList(reload: false) { (_, _) in
            self.dataStore.getCityRating(reload: false, id: id) { (rating, error) in
                result = rating
                expectation.fulfill()
            }
        }

        // then
        wait(for: [expectation], timeout: kAsyncTimeout)
        XCTAssertEqual(result?.id, id)
    }

    func testThatItHitsNetworkWhenReloadingCityRating() throws {
        let expectation = XCTestExpectation(description: "Got cities")

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
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: kAsyncTimeout)
        XCTAssertEqual(self.mockNetworkService.fetchCityRatingInvocationCounter, 3)
    }

    func testThatItHitsNetworkWhenReloadingCityPopulation() throws {
        let expectation = XCTestExpectation(description: "Got cities")

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
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: kAsyncTimeout)
        XCTAssertEqual(self.mockNetworkService.fetchCityPopulationInvocationCounter, 3)
    }

    func testThatItRelaysFavoriteManagerCalls() {
        // given
        guard let id = mockNetworkService.cityList.first?.id else {
            XCTFail()
            return
        }

        // when
        dataStore.addToFavorites(id: id)
        dataStore.removeFromFavorites(id: id)
        _ = dataStore.isCityFavorite(id: id)

        // then
        XCTAssertEqual(mockFavoriteCitiesManager.addToFavoritesInvocationCount, 1)
        XCTAssertEqual(mockFavoriteCitiesManager.removeFromFavoritesInvocationCount, 1)
        XCTAssertEqual(mockFavoriteCitiesManager.isCityFavoriteInvocationCount, 1)
    }

}

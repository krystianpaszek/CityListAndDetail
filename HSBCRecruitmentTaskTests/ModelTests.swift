//
//  ModelTests.swift
//  HSBCRecruitmentTaskTests
//
//  Created by Krystian Paszek on 20/11/2020.
//

@testable import HSBCRecruitmentTask
import XCTest

class ModelTests: XCTestCase {

    // MARK: - Properties
    var mockNetworkService: MockNetworkService!

    // MARK: - Setup
    override func setUp() {
        mockNetworkService = MockNetworkService()
    }

    // MARK: - Tests
    func testCityModel() throws {
        // given
        let cityList = mockNetworkService.cityList
        guard
            let firstCity = cityList.first,
            let lastCity = cityList.last
        else {
            XCTFail("cityList is empty")
            return
        }

        // then
        XCTAssertEqual(cityList.count, 4)

        XCTAssertEqual(firstCity.name, "Boston")
        XCTAssertEqual(firstCity.id.uuidString, "02FCD224-6631-4FD7-BD35-91BCF0E90D15")
        XCTAssertEqual(firstCity.image.absoluteString, "https://www.langan.com/wp-content/uploads/2019/02/Boston-996x554.jpg")

        XCTAssertEqual(lastCity.name, "Warszawa")
        XCTAssertEqual(lastCity.id.uuidString, "14650E3B-4BE7-4F78-AB32-F5B209F2D728")
        XCTAssertEqual(lastCity.image.absoluteString, "https://urbnews.pl/wp-content/uploads/2018/10/warszawa-widok.jpg")
    }

    func testCityPopulationModel() throws {
        // given
        let cityPopulation = mockNetworkService.cityPopulation

        // then
        XCTAssertEqual(cityPopulation.id.uuidString, "14650E3B-4BE7-4F78-AB32-F5B209F2D728")
        XCTAssertEqual(cityPopulation.population, 1790658)
    }

    func testCityRatingModel() throws {
        // given
        let cityRating = mockNetworkService.cityRating

        // then
        XCTAssertEqual(cityRating.id.uuidString, "14650E3B-4BE7-4F78-AB32-F5B209F2D728")
        XCTAssertEqual(cityRating.rating, 4.5)
    }

}

//
//  MockNetworkService.swift
//  CitiesListAndDetailTests
//
//  Created by Krystian Paszek on 15/11/2020.
//

@testable import CitiesListAndDetail
import UIKit

class MockNetworkService: NetworkServiceProtocol {

    // MARK: - JSONs
    var cityListJSON: Data {
        """
        [
            {
                "id": "02FCD224-6631-4FD7-BD35-91BCF0E90D15",
                "name": "Boston",
                "image": "https://www.langan.com/wp-content/uploads/2019/02/Boston-996x554.jpg",
            },
            {
                "id": "42656040-33C7-45E2-9324-B91189496225",
                "name": "Berlin",
                "image": "https://www.thebellevoyage.com/wp-content/uploads/2018/02/berlin-germany-itinerary-travel-guide-8.jpg"
            },
            {
                "id": "3D9CAC2A-8E94-4BD5-8046-49B0E621827F",
                "name": "Delhi",
                "image": "https://cdn.getyourguide.com/img/tour/5c981ca642f11.jpeg/146.jpg"
            },
            {
                "id": "14650E3B-4BE7-4F78-AB32-F5B209F2D728",
                "name": "Warszawa",
                "image": "https://urbnews.pl/wp-content/uploads/2018/10/warszawa-widok.jpg"
            }
        ]
        """.data(using: .utf8)!
    }

    var cityPopulationJSON: Data {
        """
        {
            "id": "14650E3B-4BE7-4F78-AB32-F5B209F2D728",
            "population": 1790658
        }
        """.data(using: .utf8)!
    }

    var cityRatingJSON: Data {
        """
        {
            "id": "14650E3B-4BE7-4F78-AB32-F5B209F2D728",
            "rating": 4.5
        }
        """.data(using: .utf8)!
    }

    // MARK: - Responses
    lazy var cityList: [City] = {
        let cities = try! JSONDecoder().decode([City].self, from: cityListJSON)
        return cities
    }()

    lazy var cityPopulation: CityPopulation = {
        let cityPopulation = try! JSONDecoder().decode(CityPopulation.self, from: cityPopulationJSON)
        return cityPopulation
    }()

    lazy var cityRating: CityRating = {
        let cityRating = try! JSONDecoder().decode(CityRating.self, from: cityRatingJSON)
        return cityRating
    }()

    // MARK: - Counters
    var fetchCityListInvocationCounter: Int = 0
    var fetchCityPopulationInvocationCounter: Int = 0
    var fetchCityRatingInvocationCounter: Int = 0

    // MARK: - NetworkServiceProtocol
    func fetchCityList(completion: @escaping ([City]?, Error?) -> Void) {
        fetchCityListInvocationCounter += 1
        completion(cityList, nil)
    }

    func fetchCityPopulation(id: UUID, completion: @escaping (CityPopulation?, Error?) -> Void) {
        fetchCityPopulationInvocationCounter += 1
        completion(cityPopulation, nil)
    }

    func fetchCityRating(id: UUID, completion: @escaping (CityRating?, Error?) -> Void) {
        fetchCityRatingInvocationCounter += 1
        completion(cityRating, nil)
    }

}

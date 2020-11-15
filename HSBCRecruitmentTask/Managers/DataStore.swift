//
//  DataStore.swift
//  HSBCRecruitmentTask
//
//  Created by Krystian Paszek on 15/11/2020.
//

import Foundation

enum DataStoreError: Error {
    case noResourceFound
}

class DataStore: DataStoreProtocol {

    // MARK: - Dependencies
    private let networkService: NetworkServiceProtocol
    private let favoritesManager: CityFavoriting

    // MARK: - State
    var cities: [UUID: City]?

    // MARK: - Initialization
    init(networkService: NetworkServiceProtocol, favoritesManager: CityFavoriting) {
        self.networkService = networkService
        self.favoritesManager = favoritesManager
    }
}

// MARK: - DataStoreProtocol
extension DataStore {
    func getCityList(reload: Bool, completion: @escaping ([City]?, Error?) -> Void) {
        guard let cities = cities, !reload else {
            // it has to cache result here
            networkService.fetchCityList(completion: completion)
            return
        }

        let values: [City] = Array(cities.values)
        completion(values, nil)
    }

    func getCity(id: UUID, completion: @escaping (City?, Error?) -> Void) {
        guard let city = cities?[id] else {
            completion(nil, DataStoreError.noResourceFound)
            return
        }

        completion(city, nil)
    }

    func getCityPopulation(reload: Bool, id: UUID, completion: @escaping (CityPopulation?, Error?) -> Void) {
        // it has to cache result here
        guard let cityPopulation = cities?[id]?.population, !reload else {
            networkService.fetchCityPopulation(id: id, completion: completion)
            return
        }

        completion(cityPopulation, nil)
    }

    func getCityRating(reload: Bool, id: UUID, completion: @escaping (CityRating?, Error?) -> Void) {
        // it has to cache result here
        guard let cityRating = cities?[id]?.rating, !reload else {
            networkService.fetchCityRating(id: id, completion: completion)
            return
        }

        completion(cityRating, nil)
    }

    func isCityFavorite(id: UUID) -> Bool {
        favoritesManager.isCityFavorite(id: id)
    }

    func addToFavorites(id: UUID) {
        favoritesManager.addToFavorites(id: id)
    }

    func removeFromFavorites(id: UUID) {
        favoritesManager.removeFromFavorites(id: id)
    }
}

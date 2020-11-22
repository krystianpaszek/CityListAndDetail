//
//  DataStore.swift
//  CitiesListAndDetail
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
    // In real life scenario a dedicated object could take care of managing cache
    private var cities: [UUID: City]?
    private var orderedCities: [City]? {
        cities?.values.sorted(by: { $0.name < $1.name })
    }

    // MARK: - Initialization
    init(networkService: NetworkServiceProtocol, favoritesManager: CityFavoriting) {
        self.networkService = networkService
        self.favoritesManager = favoritesManager
    }
}

// MARK: - DataStoreProtocol
extension DataStore {
    func getCityList(reload: Bool, completion: @escaping ([City]?, Error?) -> Void) {
        guard let orderedCities = orderedCities, !reload else {
            networkService.fetchCityList { [weak self] (cities, error) in
                self?.cities = cities?.reduce(into: [UUID: City](), { $0[$1.id] = $1 })
                completion(self?.orderedCities, error)
            }

            return
        }

        completion(orderedCities, nil)
    }

    func getCity(withID id: UUID) -> City? {
        guard let city = cities?[id] else { return nil }
        return city
    }

    func getCityPopulation(reload: Bool, id: UUID, completion: @escaping (CityPopulation?, Error?) -> Void) {
        guard let cityPopulation = cities?[id]?.population, !reload else {
            networkService.fetchCityPopulation(id: id) { [weak self] cityPopulation, error in
                self?.cities?[id]?.population = cityPopulation
                completion(cityPopulation, error)
            }
            
            return
        }

        completion(cityPopulation, nil)
    }

    func getCityRating(reload: Bool, id: UUID, completion: @escaping (CityRating?, Error?) -> Void) {
        guard let cityRating = cities?[id]?.rating, !reload else {
            networkService.fetchCityRating(id: id) { [weak self] cityRating, error in
                self?.cities?[id]?.rating = cityRating
                completion(cityRating, error)
            }

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

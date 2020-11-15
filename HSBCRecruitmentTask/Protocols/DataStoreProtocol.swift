//
//  DataStoreProtocol.swift
//  HSBCRecruitmentTask
//
//  Created by Krystian Paszek on 15/11/2020.
//

import Foundation

protocol DataStoreProtocol {
    func getCityList(reload: Bool, completion: @escaping ([City]?, Error?) -> Void)
    func getCity(id: UUID, completion: @escaping (City?, Error?) -> Void)
    func getCityPopulation(reload: Bool, id: UUID, completion: @escaping (CityPopulation?, Error?) -> Void)
    func getCityRating(reload: Bool, id: UUID, completion: @escaping (CityRating?, Error?) -> Void)

    func isCityFavorite(id: UUID) -> Bool
    func addToFavorites(id: UUID)
    func removeFromFavorites(id: UUID)
}

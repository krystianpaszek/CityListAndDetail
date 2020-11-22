//
//  NetworkServiceProtocol.swift
//  CitiesListAndDetail
//
//  Created by Krystian Paszek on 15/11/2020.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetchCityList(completion: @escaping ([City]?, Error?) -> Void)
    func fetchCityPopulation(id: UUID, completion: @escaping (CityPopulation?, Error?) -> Void)
    func fetchCityRating(id: UUID, completion: @escaping (CityRating?, Error?) -> Void)
}

//
//  NetworkServiceProtocol.swift
//  HSBCRecruitmentTask
//
//  Created by Krystian Paszek on 15/11/2020.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetchCityList(completion: @escaping ([City]) throws -> Void)
    func fetchCityPopulation(id: String, completion: @escaping (Int) throws -> Void)
    func fetchCityRating(id: String, completion: @escaping (Float) throws -> Void)
}

//
//  DataStoreProtocol.swift
//  HSBCRecruitmentTask
//
//  Created by Krystian Paszek on 15/11/2020.
//

import Foundation

protocol DataStoreProtocol {
    func getCityList(completion: @escaping ([City]) throws -> Void)
    func getCity(uuid: UUID, completion: @escaping (City) throws -> Void)
    func getCityPopulation(uuid: UUID, completion: @escaping (Int) throws -> Void)
    func getCityRating(uuid: UUID, completion: @escaping (Float) throws -> Void)
}

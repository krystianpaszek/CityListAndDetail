//
//  CityFavoriting.swift
//  HSBCRecruitmentTask
//
//  Created by Krystian Paszek on 15/11/2020.
//

import Foundation

protocol CityFavoriting {
    func addToFavorites(id: UUID)
    func removeFromFavorites(id: UUID)
    func isCityFavorite(id: UUID) -> Bool
}

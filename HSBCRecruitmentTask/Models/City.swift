//
//  City.swift
//  HSBCRecruitmentTask
//
//  Created by Krystian Paszek on 15/11/2020.
//

import Foundation

// Models could use their own, strongly typed identifiers
struct City: Identifiable, Decodable {
    let id: UUID
    let name: String
    let image: URL

    var population: CityPopulation?
    var rating: CityRating?
}

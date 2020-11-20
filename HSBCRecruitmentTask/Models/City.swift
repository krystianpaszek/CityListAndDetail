//
//  City.swift
//  HSBCRecruitmentTask
//
//  Created by Krystian Paszek on 15/11/2020.
//

import Foundation

// Models could use their own, strongly typed identifiers
struct City: Identifiable, Equatable, Decodable {

    let id: UUID
    let name: String
    let image: URL

    var population: CityPopulation?
    var rating: CityRating?

    static func == (lhs: City, rhs: City) -> Bool {
        return lhs.id == rhs.id
    }

}

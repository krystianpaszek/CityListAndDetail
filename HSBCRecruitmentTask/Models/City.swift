//
//  City.swift
//  HSBCRecruitmentTask
//
//  Created by Krystian Paszek on 15/11/2020.
//

import Foundation

struct City: Identifiable, Decodable {
    let id: UUID
    let name: String
    let image: URL
}

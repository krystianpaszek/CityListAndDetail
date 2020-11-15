//
//  NetworkServiceConfiguration.swift
//  HSBCRecruitmentTask
//
//  Created by Krystian Paszek on 15/11/2020.
//

import Foundation

struct NetworkServiceConfiguration {
    let session: URLSession
    let baseURL: URL

    static var `default`: Self {
        NetworkServiceConfiguration(session: .shared, baseURL: URL(string: "https://gist.githubusercontent.com/krystianpaszek/281b1839b1de48d14097aecd1e7c330e/raw/704963089134bdd81b3336f0f8b87dd0418cb525")!)
    }
}

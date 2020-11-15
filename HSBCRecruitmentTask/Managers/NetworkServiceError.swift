//
//  NetworkServiceError.swift
//  HSBCRecruitmentTask
//
//  Created by Krystian Paszek on 15/11/2020.
//

import Foundation

enum NetworkServiceError: Error {
    case cannotConstructURL
    case cannotFetchResource
    case cannotDecodeResource
    case unknownError
}

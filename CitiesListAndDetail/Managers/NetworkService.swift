//
//  NetworkService.swift
//  CitiesListAndDetail
//
//  Created by Krystian Paszek on 15/11/2020.
//

import Foundation

class NetworkService: NetworkServiceProtocol {

    // MARK: - Properties
    private let configuration: NetworkServiceConfiguration
    private var session: URLSession { configuration.session }
    private var baseURL: URL { configuration.baseURL }

    // MARK: - Initialization
    init(configuration: NetworkServiceConfiguration) {
        self.configuration = configuration
    }

    // MARK: - Private functions
    private func decodedResponse<T: Decodable>(for url: URL, completion: @escaping (T?, Error?) -> Void) {
        session.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                completion(nil, NetworkServiceError.cannotFetchResource)
                return
            }

            guard let decodedData = try? JSONDecoder().decode(T.self, from: data) else {
                completion(nil, NetworkServiceError.cannotDecodeResource)
                return
            }

            completion(decodedData, nil)
        }.resume()
    }

    private func constructAndDecode<T: Decodable>(route: Route, completion: @escaping (T?, Error?) -> Void) {
        do {
            let url = try constructUrl(route: route)
            return decodedResponse(for: url, completion: completion)
        } catch {
            completion(nil, error)
        }
    }

}

// MARK: - NetworkServiceProtocol
extension NetworkService {

    func fetchCityList(completion: @escaping ([City]?, Error?) -> Void) {
        constructAndDecode(route: .cityList, completion: completion)
    }

    func fetchCityPopulation(id: UUID, completion: @escaping (CityPopulation?, Error?) -> Void) {
        constructAndDecode(route: .cityPopulation(id: id), completion: completion)
    }

    func fetchCityRating(id: UUID, completion: @escaping (CityRating?, Error?) -> Void) {
        constructAndDecode(route: .cityRating(id: id), completion: completion)
    }

}

// MARK: - Routing
extension NetworkService {

    private enum Route {
        case cityList
        case cityRating(id: UUID)
        case cityPopulation(id: UUID)

        // UUIDs not used in the process of routing on purpose; in real life scenario this could be used to construct resource path
        func path() -> String {
            switch self {
            case .cityList:
                return "cities.json"
            case .cityRating(_):
                return "rating.json"
            case .cityPopulation(_):
                return "population.json"
            }
        }
    }

    private func constructUrl(route: Route) throws -> URL {
        // Could use URLComponents in future for more complicated queries
        guard let url = URL(string: route.path(), relativeTo: baseURL) else {
            throw NetworkServiceError.cannotConstructURL
        }

        return url
    }

}

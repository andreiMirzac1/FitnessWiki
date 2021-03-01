//
//  ExercisesWebRepository.swift
//  FitnessWiki
//
//  Created by Andrei Mirzac on 17/01/2021.
//

import Foundation

protocol ExercisesWebRepository: WebRepository {
    func fetchExercises(page: String?, completion: @escaping (Result<ListingData<[Exercise]>, Error>) -> Void)
    func fetchExercises(filter: Filter, completion: @escaping (Result<ListingData<[Exercise]>, Error>) -> Void)
}

class RealExercisesWebRepository: ExercisesWebRepository {
    var session: URLSession

    var baseURL: String

    var queue: DispatchQueue = DispatchQueue(label: "backgroundQueue")

    init(session: URLSession = URLSession.shared, baseURL: String) {
        self.session = session
        self.baseURL = baseURL
    }

    func fetchExercises(page: String? = nil, completion: @escaping (Result<ListingData<[Exercise]>, Error>) -> Void) {
        call(endpoint: API.exercises(page: page), completion: completion)
    }

    func fetchExercises(filter: Filter, completion: @escaping (Result<ListingData<[Exercise]>, Error>) -> Void) {
        call(endpoint: API.exercisesFilterBy(filter: filter), completion: completion)
    }

}

extension RealExercisesWebRepository {
    enum API: APICall {
        case exercises(page: String?)
        case exercisesFilterBy(filter: Filter)

        var path: String? {
            switch self {
            case .exercises(let page):
                if let page = page {
                    return URLComponents(string: page)?.path
                } else {
                    return "/api/v2/exerciseinfo/"
                }

            case .exercisesFilterBy:
                return "/api/v2/exerciseinfo/"
            }
        }

        var queryItems: [URLQueryItem] {
            switch self {
            case .exercises(let page):
                return page.flatMap({ URLComponents(string: $0)?.queryItems }) ??
                    [URLQueryItem(name: "language", value: "2")]

            case .exercisesFilterBy(let filter):
                return [URLQueryItem(name: "language", value: "2"),
                        URLQueryItem(name: filter.name, value: String(filter.id))]
            }
        }

        var method: String {
            "GET"
        }

        var headers: [String : String]? {
            [
                "Accept": "application/json",
                "Authorization":"Token 9b49e0dbdf8bd1f9355358845ace8817ba970d3e"
            ]
        }

        func body() throws -> Data? {
            nil
        }
    }
}




//
//  Endpoint.swift
//  TheMovieDB
//
//  Created by Sebastiano Catellani on 09.09.18.
//  Copyright © 2018 Sebastiano Catellani. All rights reserved.
//

enum Endpoint {

    case search(String, Int)

    var method: HTTPMethod {
        return .get
    }

    var path: String {
        switch self {
        case .search:
            return "/search/movie"
        }
    }

    var query: String? {
        switch self {
        case .search(let query, let page):
            return "query=\(query)&page=\(page)"
        }
    }
}

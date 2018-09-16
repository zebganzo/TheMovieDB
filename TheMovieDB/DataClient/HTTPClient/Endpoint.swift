//
//  Endpoint.swift
//  TheMovieDB
//
//  Created by Sebastiano Catellani on 09.09.18.
//  Copyright © 2018 Sebastiano Catellani. All rights reserved.
//

enum Poster​Size: String {
    case ​w92 = "w92"
    case w185 = "w185"
    case ​w500 = "w500"
    case w780 = "w780"
}

enum Endpoint {

    case search(String, Int)
    case image(String, Poster​Size)

    var method: HTTPMethod {
        return .get
    }

    var path: String {
        switch self {
        case .search:
            return "/search/movie"
        case .image(let name, let size):
            return "/t/p/\(size.rawValue)/\(name)"
        }
    }

    var query: String? {
        switch self {
        case .search(let query, let page):
            return "query=\(query)&page=\(page)"
        case .image:
            return nil
        }
    }
}

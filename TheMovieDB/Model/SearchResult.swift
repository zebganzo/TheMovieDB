//
//  SearchResult.swift
//  TheMovieDB
//
//  Created by Sebastiano Catellani on 12.09.18.
//  Copyright © 2018 Sebastiano Catellani. All rights reserved.
//

struct SearchResult<U: Decodable>: Decodable {
    let page: Int
    let totalResults: Int
    let totalPages: Int
    let results: [U]

    enum CodingKeys: String, CodingKey {
        case page = "page"
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case results = "results"
    }
}

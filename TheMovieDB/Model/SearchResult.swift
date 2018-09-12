//
//  SearchResult.swift
//  TheMovieDB
//
//  Created by Sebastiano Catellani on 12.09.18.
//  Copyright © 2018 Sebastiano Catellani. All rights reserved.
//

struct SearchResult<U: Unmarshalling> {
    let page: Int
    let totalResults: Int
    let totalPages: Int
    let results: [U]
}

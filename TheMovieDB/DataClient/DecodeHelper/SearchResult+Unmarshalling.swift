//
//  SearchResult+Unmarshalling.swift
//  TheMovieDB
//
//  Created by Sebastiano Catellani on 12.09.18.
//  Copyright © 2018 Sebastiano Catellani. All rights reserved.
//

extension SearchResult: Unmarshalling {
    init(json: JSON) throws {
        guard let page = json["page"] as? Int
            , let totalResults = json["total_results"] as? Int
            , let totalPages = json["total_pages"] as? Int
            , let anyResults = json["results"] as? [JSON]
            else { throw DecodingError.invalidJSON(json) }
        self.page = page
        self.totalResults = totalResults
        self.totalPages = totalPages
        self.results = try anyResults.unmarshal()
    }
}

//
//  Movie+Unmarshalling.swift
//  TheMovieDB
//
//  Created by Sebastiano Catellani on 12.09.18.
//  Copyright © 2018 Sebastiano Catellani. All rights reserved.
//

extension Movie: Unmarshalling {
    init(json: JSON) throws {
        guard let name = json["title"] as? String
            , let posterPath = json["poster_path"] as? String
            , let releaseDate = json["release_date"] as? String
            , let overview = json["overview"] as? String
            else { throw DecodingError.invalidJSON(json) }
        self.​name = name
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.overview = overview
    }
}

//
//  Movie.swift
//  TheMovieDB
//
//  Created by Sebastiano Catellani on 12.09.18.
//  Copyright © 2018 Sebastiano Catellani. All rights reserved.
//

struct Movie: Decodable {
    let ​name: String
    let posterPath: String
    let releaseDate: String
    let overview: String

    enum CodingKeys: String, CodingKey {
        case ​name = "title"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case overview = "overview"
    }
}

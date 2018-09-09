//
//  Result.swift
//  TheMovieDB
//
//  Created by Sebastiano Catellani on 09.09.18.
//  Copyright © 2018 Sebastiano Catellani. All rights reserved.
//

enum Result<T, Error: Swift.Error> {
    case success(T)
    case failure(Error)
}

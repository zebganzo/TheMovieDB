//
//  Unmarshalling.swift
//  TheMovieDB
//
//  Created by Sebastiano Catellani on 12.09.18.
//  Copyright © 2018 Sebastiano Catellani. All rights reserved.
//

import Foundation

public typealias JSON = [String: Any]

public protocol Unmarshalling {
    init(json: JSON) throws
}

enum DecodingError: Error {
    case invalidJSON(Any)
    case invalidData(Any)
}

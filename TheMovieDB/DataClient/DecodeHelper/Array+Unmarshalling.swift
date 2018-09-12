//
//  Array+Unmarshalling.swift
//  TheMovieDB
//
//  Created by Sebastiano Catellani on 12.09.18.
//  Copyright © 2018 Sebastiano Catellani. All rights reserved.
//

extension Sequence where Element == JSON {
    func unmarshal<U>() throws -> [U] where U: Unmarshalling {
        do {
            return try self.compactMap { try U.init(json: $0) }
        } catch {
            throw DecodingError.invalidJSON(self)
        }
    }
}

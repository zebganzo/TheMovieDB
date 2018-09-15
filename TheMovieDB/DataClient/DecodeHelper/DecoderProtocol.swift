//
//  DecoderProtocol.swift
//  TheMovieDB
//
//  Created by Sebastiano Catellani on 15.09.18.
//  Copyright © 2018 Sebastiano Catellani. All rights reserved.
//

import Foundation

protocol DecoderProtocol {
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable
}

extension JSONDecoder: DecoderProtocol { }

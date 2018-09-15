//
//  APIClient.swift
//  TheMovieDB
//
//  Created by Sebastiano Catellani on 12.09.18.
//  Copyright © 2018 Sebastiano Catellani. All rights reserved.
//

import Foundation

final class APIClient {
    private let httpLayer: HttpLayerProtocol
    private let decoder: DecoderProtocol
    init(httpLayer: HttpLayerProtocol, decoder: DecoderProtocol) {
        self.httpLayer = httpLayer
        self.decoder = decoder
    }
}

enum APIError: Error {
    case badRequest(NSError)
    case dataBadFormatted
    case dataMissing
}

protocol SearchProtocol {
    func search(movie name: String, page: Int, completion: @escaping (Result<SearchResult<Movie>, APIError>) -> Void)
}

extension APIClient: SearchProtocol {
    func search(movie name: String, page: Int = 1, completion: @escaping (Result<SearchResult<Movie>, APIError>) -> Void) {
        // TODO: Has to be greater than 0. Handle specific error.
        self.httpLayer.request(at: .search(name, page)) { [weak self] result in
            guard let `self` = self else { return }

            switch result {
            case .success(let data):
                guard let searchResult = try? self.decoder.decode(SearchResult<Movie>.self, from: data) else {
                    completion(.failure(.dataBadFormatted))
                    return
                }

                completion(.success(searchResult))
            case .failure(let error):
                print(error)
            }
        }
    }
}

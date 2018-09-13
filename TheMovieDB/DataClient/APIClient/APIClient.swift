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
    init(httpLayer: HttpLayerProtocol) {
        self.httpLayer = httpLayer
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
        self.httpLayer.request(at: .search(name, page)) { result in
            switch result {
            case .success(let data):
                guard let json = try? JSONSerialization.jsonObject(with: data) as! JSON
                    , let searchResult = try? SearchResult<Movie>(json: json) else {
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

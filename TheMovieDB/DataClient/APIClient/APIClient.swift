//
//  APIClient.swift
//  TheMovieDB
//
//  Created by Sebastiano Catellani on 12.09.18.
//  Copyright © 2018 Sebastiano Catellani. All rights reserved.
//

import Foundation

final class APIClient {
    private let movieHttpLayer: HttpLayerProtocol
    private let imageHttpLayer: HttpLayerProtocol
    private let decoder: DecoderProtocol
    init(movieHttpLayer: HttpLayerProtocol, imageHttpLayer: HttpLayerProtocol, decoder: DecoderProtocol) {
        self.imageHttpLayer = imageHttpLayer
        self.movieHttpLayer = movieHttpLayer
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

protocol ImageProtocol {
    func movieImageURL(movie posterPath: String, posterSize size: Poster​Size) -> URL?
}

protocol ApiClientProtocol: ImageProtocol & SearchProtocol { }
extension APIClient: ApiClientProtocol { }

extension APIClient: SearchProtocol {
    func search(movie name: String, page: Int = 1, completion: @escaping (Result<SearchResult<Movie>, APIError>) -> Void) {
        // TODO: Has to be greater than 0. Handle specific error.
        self.movieHttpLayer.request(at: .search(name, page)) { [weak self] result in
            guard let `self` = self else { return }

            switch result {
            case .success(let data):
                var searchResult: SearchResult<Movie>
                do {
                    searchResult = try self.decoder.decode(SearchResult<Movie>.self, from: data)
                    completion(.success(searchResult))
                } catch let error {
                    print("[Deconding] \(error.localizedDescription)")
                    completion(.failure(.dataBadFormatted))
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension APIClient: ImageProtocol {
    func movieImageURL(movie posterPath: String, posterSize size: Poster​Size) -> URL? {
        return self.imageHttpLayer.buildUrl(endpoint: Endpoint.image(posterPath, size))
    }
}

//
//  HTTPLayer.swift
//  TheMovieDB
//
//  Created by Sebastiano Catellani on 09.09.18.
//  Copyright © 2018 Sebastiano Catellani. All rights reserved.
//

import Foundation

enum HTTPError: Error {
    case badEndpoint(Endpoint)
    case badRequest(Error)
    case unknownError
}

typealias completionHandler = (Result<Data, HTTPError>) -> Void

protocol HTTPLayerProtocol {
    func request(at endpoint: Endpoint, completion: @escaping completionHandler)
}

enum HTTPMethod: String {
    case get = "GET"
}

final class HTTPLayer: HTTPLayerProtocol {

    private let baseURL: URL
    private let version: Int
    private let apiKey: String

    init?(apiKey: String, baseURL: String, version: Int) {
        guard let baseURL = URL(string: baseURL) else { return nil }
        self.apiKey = apiKey
        self.baseURL = baseURL
        self.version = version
    }

    func request(at endpoint: Endpoint, completion: @escaping completionHandler) {

        guard let url = self.url(with: self.baseURL, version: self.version, endpoint: endpoint) else {

            assertionFailure("Unable to create an URL")
            completion(.failure(.badEndpoint(endpoint)))
            return
        }

        print("[Networking] Request: \(url.absoluteString)")

        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let data = data {
                completion(.success(data))
                return
            }

            guard let error = error else {
                completion(.failure(.unknownError))
                return
            }

            completion(.failure(.badRequest(error)))
        }
        task.resume()
    }

    func url(with baseURL: URL, version: Int, endpoint: Endpoint) -> URL? {
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        urlComponents?.path = "/" + String(version) + endpoint.path
        urlComponents?.query = (endpoint.query ?? "") + "&api_key=\(self.apiKey)"
        return urlComponents?.url
    }
}

//
//  HTTPLayer.swift
//  TheMovieDB
//
//  Created by Sebastiano Catellani on 09.09.18.
//  Copyright © 2018 Sebastiano Catellani. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
}

enum HTTPError: Error {
    case badEndpoint(Endpoint)
    case badRequest(Error)
    case unknownError
}

typealias completionHandler = (Result<Data, HTTPError>) -> Void

protocol HttpLayerProtocol {
    func request(at endpoint: Endpoint, completion: @escaping completionHandler)
    func buildUrl(endpoint: Endpoint) -> URL?
}

extension HttpLayerProtocol {

    func request(at endpoint: Endpoint, completion: @escaping completionHandler) {
        guard let url = self.buildUrl(endpoint: endpoint) else {
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
}

final class ImageHttpLayer: HttpLayerProtocol {

    private let baseURL: URL

    init?(baseURL: String) {
        guard let baseURL = URL(string: baseURL) else { return nil }
        self.baseURL = baseURL
    }

    func buildUrl(endpoint: Endpoint) -> URL? {
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        urlComponents?.path = endpoint.path
        urlComponents?.query = endpoint.query
        return urlComponents?.url
    }
}

final class AuthenticatedHttpLayer: HttpLayerProtocol {

    private let baseURL: URL
    private let version: Int
    private let apiKey: String

    init?(apiKey: String, baseURL: String, version: Int) {
        guard let baseURL = URL(string: baseURL) else { return nil }
        self.apiKey = apiKey
        self.baseURL = baseURL
        self.version = version
    }

    private func authenticate(query: String?) -> String {
        return (query ?? "") + "&api_key=\(self.apiKey)"
    }

    func buildUrl(endpoint: Endpoint) -> URL? {
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        urlComponents?.path = "/" + String(version) + endpoint.path
        urlComponents?.query = self.authenticate(query: endpoint.query)
        return urlComponents?.url
    }
}

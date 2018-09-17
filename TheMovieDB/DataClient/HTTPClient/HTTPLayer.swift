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
    case badBaseUrl(String)
    case badEndpoint(Endpoint)
    case badRequest(Error)
    case unknownError
}

typealias CompletionHandler = (Result<Data, HTTPError>) -> Void

protocol HttpLayerProtocol {
    func request(at endpoint: Endpoint, completion: @escaping CompletionHandler)
    func buildUrl(endpoint: Endpoint) -> URL?
}

extension HttpLayerProtocol {

    func request(at endpoint: Endpoint, completion: @escaping CompletionHandler) {
        guard let url = self.buildUrl(endpoint: endpoint) else {
            assertionFailure("Unable to create an URL")
            completion(.failure(.badEndpoint(endpoint)))
            return
        }

        print("[Networking] Request: \(url.absoluteString)")

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in

            // https://www.themoviedb.org/documentation/api/status-codes
            if let statuCode = response?.statusCode() {
                print("[Networking] Response statut code: \(statuCode)")
            }

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

extension URLResponse {
    func statusCode() -> Int? {
        if let httpResponse = self as? HTTPURLResponse {
            return httpResponse.statusCode
        }
        return nil
    }
}

final class ImageHttpLayer: HttpLayerProtocol {

    private let baseURL: URL

    init(baseUrl stringUrl: String) throws {
        guard let baseURL = URL(string: stringUrl) else { throw HTTPError.badBaseUrl(stringUrl) }
        self.baseURL = baseURL
    }

    func buildUrl(endpoint: Endpoint) -> URL? {
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        urlComponents?.path = endpoint.path
        urlComponents?.query = endpoint.query
        return urlComponents?.url
    }
}

final class MovieHttpLayer: HttpLayerProtocol {

    private let baseURL: URL
    private let version: Int
    private let apiKey: String

    init(apiKey: String, baseUrl stringUrl: String, version: Int) throws {
        guard let baseURL = URL(string: stringUrl) else { throw HTTPError.badBaseUrl(stringUrl) }
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

//
//  MovieSearchViewModel.swift
//  TheMovieDB
//
//  Created by Sebastiano Catellani on 13.09.18.
//  Copyright © 2018 Sebastiano Catellani. All rights reserved.
//

import ReactiveSwift
import Result

protocol MovieSearchProtocol {
    var searchAction: Action<String, SearchResult<Movie>, AnyError> { get }
}

enum SearchError: Error {
    case dataMissing
}

class MovieSearchViewModel: MovieSearchProtocol {

    private let searchClient: SearchProtocol
    let searchAction: Action<String, SearchResult<Movie>, AnyError>

    init(searchClient: SearchProtocol) {
        self.searchClient = searchClient

        self.searchAction = Action { (name: String) -> SignalProducer<SearchResult<Movie>, AnyError> in
            return SignalProducer<SearchResult<Movie>, AnyError> { observer, _ in
                searchClient.search(movie: name, page: 1) { result in
                    switch result {
                    case .success(let searchResult):
                        observer.send(value: searchResult)
                        observer.sendCompleted()
                    case .failure(let error):
                        observer.send(error: AnyError(error))
                    }
                }
            }
        }
    }
}

extension MovieSearchViewModel: RouterViewModelProtocol {
    var mainActionOutput: MainActionOutput {
        print("MainActionOutput")
        return self.searchAction.values.producer
            .map { $0 as Any }
            .mapError { AnyError($0) }
    }
}

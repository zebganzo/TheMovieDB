//
//  MovieSearchViewModel.swift
//  TheMovieDB
//
//  Created by Sebastiano Catellani on 13.09.18.
//  Copyright © 2018 Sebastiano Catellani. All rights reserved.
//

import ReactiveSwift
import Result

protocol MovieSearchProtocol: RouterViewModelProtocol {
    var searchAction: Action<String, (String, SearchResult<Movie>), SearchError> { get }
    var suggestions: MutableProperty<[Suggestion]> { get }
}

enum SearchError: Error {
    case searchError
    case noMoviesFound
}

class MovieSearchViewModel: MovieSearchProtocol {
    private let searchClient: SearchProtocol
    let searchAction: Action<String, (String, SearchResult<Movie>), SearchError>

    let suggestions: MutableProperty<[Suggestion]>

    init(searchClient: SearchProtocol, suggestionsProtocol: SuggestionsProtocol) {
        self.searchClient = searchClient
        self.suggestions = suggestionsProtocol.suggestions

        self.searchAction = Action { (name: String) -> SignalProducer<(String, SearchResult<Movie>), SearchError> in
            return SignalProducer<(String, SearchResult<Movie>), SearchError> { observer, _ in
                searchClient.search(movie: name, page: 1) { result in
                    switch result {
                    case .success(let searchResult):

                        if searchResult.results.isEmpty {
                            observer.send(error: .noMoviesFound)
                            return
                        }

                        observer.send(value: (name, searchResult))
                        observer.sendCompleted()
                    case .failure(let apiError):
                        switch apiError {
                        case .badRequest, .dataBadFormatted, .dataMissing:
                            observer.send(error: .searchError)
                        }
                    }
                }
                }.on(value: { _ in
                    suggestionsProtocol.save(suggestion: name)
                })
        }
    }
}

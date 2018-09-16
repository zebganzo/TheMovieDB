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
    var searchAction: Action<String, (String, SearchResult<Movie>), AnyError> { get }
    var suggestions: MutableProperty<[Suggestion]> { get }
}

enum SearchError: Error {
    case dataMissing
}

class MovieSearchViewModel: MovieSearchProtocol {
    private let searchClient: SearchProtocol
    let searchAction: Action<String, (String, SearchResult<Movie>), AnyError>

    let suggestions: MutableProperty<[Suggestion]>

    init(searchClient: SearchProtocol, suggestionsProtocol: SuggestionsProtocol) {
        self.searchClient = searchClient
        self.suggestions = suggestionsProtocol.suggestions

        self.searchAction = Action { (name: String) -> SignalProducer<(String, SearchResult<Movie>), AnyError> in
            return SignalProducer<(String, SearchResult<Movie>), AnyError> { observer, _ in
                searchClient.search(movie: name, page: 1) { result in
                    switch result {
                    case .success(let searchResult):
                        observer.send(value: (name, searchResult))
                        observer.sendCompleted()
                    case .failure(let error):
                        observer.send(error: AnyError(error))
                    }
                }
                }.on(value: { _ in
                    suggestionsProtocol.save(suggestion: name)
                })
        }
    }
}

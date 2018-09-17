//
//  MovieSearchViewModel.swift
//  TheMovieDB
//
//  Created by Sebastiano Catellani on 13.09.18.
//  Copyright © 2018 Sebastiano Catellani. All rights reserved.
//

import ReactiveSwift
import Result

/// It provides two variables for searching movies and suggestions.
protocol MovieSearchProtocol: RouterViewModelProtocol {

    /// This `Action` performs the research of the movies with the given query.
    /// Input: query name (`String`)
    /// Output: `Tuple` with the query performed (`String`) and the result of the search `SearchResult<Movie>`
    /// Error: specific `SearchError`.
    var searchAction: Action<String, (String, SearchResult<Movie>), SearchError> { get }

    /// `MutableProperty` that contains an array of `Suggestion`.
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

                        // In case of no movies found, it sends the corresponding error.
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
                    // As side-effect of the research, it saves the query name.
                    suggestionsProtocol.save(suggestion: name)
                })
        }
    }
}

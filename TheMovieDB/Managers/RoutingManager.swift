//
//  RoutingManager.swift
//  TheMovieDB
//
//  Created by Sebastiano Catellani on 16.09.18.
//  Copyright © 2018 Sebastiano Catellani. All rights reserved.
//

import ReactiveSwift
import Result

enum RoutingEvent {
    case entryPoint
    case action(RouterViewModel, Any)
}

protocol RoutingManagerProtocol {
    func route(with event: RoutingEvent) -> RouterViewModel?
}

protocol RouterViewModelProtocol { }

class RoutingManager {
    let searchClient: SearchProtocol
    let suggestionsClient: SuggestionsProtocol
    let imageClient: ImageProtocol

    init(searchClient: SearchProtocol,
         suggestionsProtocol: SuggestionsProtocol,
         imageClient: ImageProtocol) {
        self.searchClient = searchClient
        self.suggestionsClient = suggestionsProtocol
        self.imageClient = imageClient
    }
}

extension RoutingManager: RoutingManagerProtocol {
    func route(with event: RoutingEvent) -> RouterViewModel? {
        switch event {
            case .entryPoint:
                let movieSearchViewModel = MovieSearchViewModel(searchClient: self.searchClient, suggestionsProtocol: self.suggestionsClient)
                return .movieSearch(movieSearchViewModel)
        case .action(let routerViewModel, let output):
            switch routerViewModel {
            case .movieSearch:
                // From the search movie view(model) is possible to show only
                // the movies list showing the search results
                guard let (query, searchResult) = output as? (String, SearchResult<Movie>) else {
                    assertionFailure("The output type has to match the (String, SearchResult<Movie>) instead of \(type(of: output))")
                    return nil
                }
                let moviesListViewModel = MoviesListViewModel(searchClient: self.searchClient,
                                                              imageClient: self.imageClient,
                                                              searchResult: searchResult,
                                                              queryName: query)
                return .moviesList(moviesListViewModel)

            case .moviesList:
                // From the movies list is not possible to go any further
                assertionFailure("This case is currenctly not possible")
                return nil
            }
        }
    }
}

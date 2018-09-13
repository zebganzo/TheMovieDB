//
//  MovieSearchViewModel.swift
//  TheMovieDB
//
//  Created by Sebastiano Catellani on 13.09.18.
//  Copyright © 2018 Sebastiano Catellani. All rights reserved.
//

import ReactiveSwift
import Result

enum SearchError: Error {
    case dataMissing
}

class MovieSearchViewModel {

    private let searchClient: SearchProtocol
    let searchAction: Action<String, Void, AnyError>

    init(searchClient: SearchProtocol) {
        self.searchClient = searchClient


        self.searchAction = Action { (name: String) -> SignalProducer<Void, AnyError> in
            return SignalProducer<Void, AnyError> { observer, _ in
                searchClient.search(movie: name, page: 1) { result in
                    switch result {
                    case .success:
                        observer.sendCompleted()
                    case .failure(let error):
                        observer.send(error: AnyError(error))
                    }
                }
            }
        }
    }
}

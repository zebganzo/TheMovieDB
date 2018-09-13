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

    init(searchClient: SearchProtocol) {
        self.searchClient = searchClient
    }

    func search(movie name: String) -> SignalProducer<Void, AnyError> {

        return SignalProducer<Void, AnyError> { [weak self] observer, _ in
            guard let `self` = self else { return }

            self.searchClient.search(movie: name, page: 1) { result in
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

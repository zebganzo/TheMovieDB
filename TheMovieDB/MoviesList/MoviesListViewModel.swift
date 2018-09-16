//
//  MoviesListViewModel.swift
//  TheMovieDB
//
//  Created by Sebastiano Catellani on 13.09.18.
//  Copyright © 2018 Sebastiano Catellani. All rights reserved.
//

import ReactiveSwift

protocol MovieBasicInfoProtocol {
    var title: String { get }
}

extension Movie: MovieBasicInfoProtocol {
    var title: String {
        return self.​name
    }
}

class MoviesListViewModel {

    private let page: Int
    private let totalPages: Int
    private var movies: [Movie] = []

    private let queryName: String

    init(searchResult: SearchResult<Movie>, queryName: String) {
        self.page = searchResult.page
        self.totalPages = searchResult.totalPages
        self.movies = self.movies + searchResult.results
        self.queryName = queryName
    }

    public var pageName: String {
        return queryName
    }

    public var numberOfMovies: Int {
        return self.movies.count
    }

    public func infoForMovie(at index: Int) -> MovieBasicInfoProtocol {
        return self.movies[index]
    }
}

extension MoviesListViewModel: RouterViewModelProtocol {
    var mainActionOutput: MainActionOutput {
        return SignalProducer.empty
    }
}

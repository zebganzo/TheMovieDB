//
//  MoviesListViewModel.swift
//  TheMovieDB
//
//  Created by Sebastiano Catellani on 13.09.18.
//  Copyright © 2018 Sebastiano Catellani. All rights reserved.
//

class MoviesListViewModel {

    private let page: Int
    private let totalPages: Int
    private var movies: [Movie] = []

    init(searchResult: SearchResult<Movie>) {
        self.page = searchResult.page
        self.totalPages = searchResult.totalPages
        self.movies = self.movies + searchResult.results
    }

    public var numberOfMovies: Int {
        return self.movies.count
    }

    public func infoForMoviw(at index: Int) -> MovieBasicInfoProtocol {
        return self.movies[index]
    }
}

protocol MovieBasicInfoProtocol {
    var title: String { get }
}

extension Movie: MovieBasicInfoProtocol {
    var title: String {
        return self.​name
    }
}

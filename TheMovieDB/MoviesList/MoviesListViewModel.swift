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
}

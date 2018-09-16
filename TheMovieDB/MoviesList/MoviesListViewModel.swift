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
    var releaseData: String { get }
    var posterURL: URL? { get }
    var overview: String { get }
}

struct MovieBasicInfo: MovieBasicInfoProtocol {
    let title: String
    let releaseData: String
    let posterURL: URL?
    let overview: String
}

protocol MoviesListProtocol: RouterViewModelProtocol {
    var pageName: String { get }
    var numberOfMovies: Int { get }
    func infoForMovie(at index: Int) -> MovieBasicInfoProtocol
}

class MoviesListViewModel: MoviesListProtocol {
    private let page: Int
    private let totalPages: Int
    private var movies: [Movie] = []

    private let searchClient: SearchProtocol
    private let imageClient: ImageProtocol

    private let queryName: String

    init(searchClient: SearchProtocol, imageClient: ImageProtocol, searchResult: SearchResult<Movie>, queryName: String) {
        self.page = searchResult.page
        self.totalPages = searchResult.totalPages
        self.movies = self.movies + searchResult.results
        self.queryName = queryName
        self.searchClient = searchClient
        self.imageClient = imageClient
    }

    public var pageName: String {
        return queryName
    }

    public var numberOfMovies: Int {
        return self.movies.count
    }

    public func infoForMovie(at index: Int) -> MovieBasicInfoProtocol {
        let movie = self.movies[index]
        let posterURL = self.imageClient.movieImageURL(movie: movie.posterPath, posterSize: .​w500)
        return MovieBasicInfo(title: movie.​name, releaseData: movie.releaseDate, posterURL: posterURL, overview: movie.overview)
    }
}

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
    var posterURL: URL { get }
    var overview: String { get }
}

struct MovieBasicInfo: MovieBasicInfoProtocol {
    let title: String
    let releaseData: String
    let posterURL: URL
    let overview: String
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
        let movie = self.movies[index]
        let posterURL = URL.init(string: "http://image.tmdb.org/t/p/w500/2DtPSyODKWXluIRV7PVru0SSzja.jpg")!
        return MovieBasicInfo(title: movie.​name, releaseData: movie.releaseDate, posterURL: posterURL, overview: movie.overview)
    }
}

extension MoviesListViewModel: RouterViewModelProtocol {
    var mainActionOutput: MainActionOutput {
        return SignalProducer.empty
    }
}

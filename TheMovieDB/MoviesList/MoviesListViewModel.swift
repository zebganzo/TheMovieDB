//
//  MoviesListViewModel.swift
//  TheMovieDB
//
//  Created by Sebastiano Catellani on 13.09.18.
//  Copyright © 2018 Sebastiano Catellani. All rights reserved.
//

import ReactiveSwift
import Result

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
    func fetchIfNecessary(at index: Int)
    var fetchMoviesSignal: Signal<Void, AnyError> { get }
}

class MoviesListViewModel: MoviesListProtocol {
    private var page: Int
    private let totalPages: Int
    private var movies: [Movie] = []

    private let searchClient: SearchProtocol
    private let imageClient: ImageProtocol

    private let queryName: String

    let fetchMoviesSignal: Signal<Void, AnyError>
    private let fetchMoviesSignalSink: Signal<Void, AnyError>.Observer

    private var searchAction: Action<Void, Void, AnyError>?

    private func search() -> Action<Void, Void, AnyError> {
        return Action<Void, Void, AnyError> { _ -> SignalProducer<Void, AnyError> in
            return SignalProducer<Void, AnyError> { [weak self] observer, _ in
                guard let `self` = self else { return }

                self.searchClient.search(movie: self.queryName, page: self.page + 1) { [weak self] result in
                    guard let `self` = self else { return }
                    switch result {
                    case .success(let searchResult):
                        self.page = searchResult.page
                        
                        self.movies = self.movies + searchResult.results
                        observer.sendCompleted()
                    case .failure(let error):
                        observer.send(error: AnyError(error))
                    }
                }
                }.on(completed: { [weak self] in
                    self?.fetchMoviesSignalSink.send(value: ())
                })
        }
    }

    init(searchClient: SearchProtocol, imageClient: ImageProtocol, searchResult: SearchResult<Movie>, queryName: String) {
        self.page = searchResult.page
        self.totalPages = searchResult.totalPages
        self.movies = self.movies + searchResult.results
        self.queryName = queryName
        self.searchClient = searchClient
        self.imageClient = imageClient
        (self.fetchMoviesSignal, self.fetchMoviesSignalSink) = Signal<Void, AnyError>.pipe()
    }

    var pageName: String {
        return queryName
    }

    var numberOfMovies: Int {
        return self.movies.count
    }

    func infoForMovie(at index: Int) -> MovieBasicInfoProtocol {
        let movie = self.movies[index]
        var posterURL: URL? = nil
        if let posterPath = movie.posterPath {
            posterURL = self.imageClient.movieImageURL(movie: posterPath, posterSize: .​w500)
        }
        return MovieBasicInfo(title: movie.​name, releaseData: movie.releaseDate, posterURL: posterURL, overview: movie.overview)
    }

    func fetchIfNecessary(at index: Int) {

        // Is it already fetching new movies?
        if let searchAction = searchAction, searchAction.isExecuting.value { return }

        // Have all the pages been loaded?
        if page == totalPages { return }

        // Is it necessary to fetch new movies?
        if index < self.numberOfMovies - 1 { return }

        self.searchAction = self.search()
        self.searchAction?.apply().start()
    }
}

//
//  MoviesListViewModel.swift
//  TheMovieDB
//
//  Created by Sebastiano Catellani on 13.09.18.
//  Copyright © 2018 Sebastiano Catellani. All rights reserved.
//

import ReactiveSwift
import Result

/// Protocol that contains the info of a Movie
protocol MovieInfoProtocol {
    var title: String { get }
    var releaseDate: String { get }
    var posterURL: URL? { get }
    var overview: String { get }
}

struct MovieInfo: MovieInfoProtocol {
    let title: String
    let releaseDate: String
    let posterURL: URL?
    let overview: String
}

/// It provides the methods and the variables necessary
/// for an infinite-list of movies.
protocol MoviesListProtocol: RouterViewModelProtocol {

    /// Page name for the list screen.
    var pageName: String { get }

    /// Current number of movies.
    var numberOfMovies: Int { get }

    /// Returns the info about a movie for a given index.
    func infoForMovie(at index: Int) -> MovieInfoProtocol

    /// Notify the instance of the protocol that a movie at a given
    /// index is going to be shown and that a fetch may be necessary.
    func fetchIfNecessary(at index: Int)

    /// Signal that sends a `Void` when the fetch operation is ended.
    /// Otherwise it sends an error.
    var fetchMoviesSignal: Signal<Void, ListError> { get }
}

enum ListError: Error {
    case listError
}

class MoviesListViewModel: MoviesListProtocol {

    private var page: Int
    private let totalPages: Int
    private var movies: [Movie] = []

    private let searchClient: SearchProtocol
    private let imageClient: ImageProtocol

    private let queryName: String

    let fetchMoviesSignal: Signal<Void, ListError>
    private let fetchMoviesSignalSink: Signal<Void, ListError>.Observer

    private var fetchAction: Action<Void, Void, ListError>?

    private func fetch() -> Action<Void, Void, ListError> {
        return Action<Void, Void, ListError> { _ -> SignalProducer<Void, ListError> in
            return SignalProducer<Void, ListError> { [weak self] observer, _ in
                guard let `self` = self else { return }

                // Fetch the next page with the researched query name.
                self.searchClient.search(movie: self.queryName, page: self.page + 1) { [weak self] result in
                    guard let `self` = self else { return }
                    switch result {
                    case .success(let searchResult):

                        // Update the current page and list of movies
                        self.page = searchResult.page
                        self.movies = self.movies + searchResult.results
                        observer.sendCompleted()

                    case .failure(let apiError):
                        switch apiError {
                        case .badRequest, .dataBadFormatted, .dataMissing:
                            observer.send(error: .listError)
                        }
                    }
                }
                }.on(completed: { [weak self] in
                    // As side-effect of the fetch operation, it notifies the observes that
                    // new movies are available.
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
        (self.fetchMoviesSignal, self.fetchMoviesSignalSink) = Signal<Void, ListError>.pipe()
    }

    var pageName: String {
        return queryName
    }

    var numberOfMovies: Int {
        return self.movies.count
    }

    func infoForMovie(at index: Int) -> MovieInfoProtocol {
        let movie = self.movies[index]
        var posterURL: URL? = nil
        if let posterPath = movie.posterPath {
            posterURL = self.imageClient.movieImageURL(movie: posterPath, posterSize: .​w500)
        }
        return MovieInfo(title: movie.​name, releaseDate: movie.releaseDate, posterURL: posterURL, overview: movie.overview)
    }

    func fetchIfNecessary(at index: Int) {

        // Is it already fetching new movies?
        if let fetchAction = fetchAction, fetchAction.isExecuting.value { return }

        // Have all the pages been loaded?
        if page == totalPages { return }

        // Is it necessary to fetch new movies?
        if index < self.numberOfMovies - 1 { return }

        // Saving a reference of the current operation is mandatory for
        // keeping track of its execution.
        self.fetchAction = self.fetch()

        // Performs the fetch operation.
        self.fetchAction?.apply().start()
    }
}

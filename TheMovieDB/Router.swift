//
//  Router.swift
//  TheMovieDB
//
//  Created by Sebastiano Catellani on 13.09.18.
//  Copyright © 2018 Sebastiano Catellani. All rights reserved.
//

import ReactiveSwift
import Result

typealias MainActionOutput = SignalProducer<Any, AnyError>

protocol RouterViewModelProtocol {
    var mainActionOutput: MainActionOutput { get }
}

enum RouterViewModel {
    case movieSearch(MovieSearchViewModel)
    case moviesList(MoviesListViewModel)

    var mainActionOutput: MainActionOutput {
        switch self {
        case .movieSearch(let viewModel):
            return viewModel.mainActionOutput
        case .moviesList(let viewModel):
            return viewModel.mainActionOutput
        }
    }

    var viewModel: RouterViewModelProtocol {
        switch self {
        case .movieSearch(let viewModel):
            return viewModel
        case .moviesList(let viewModel):
            return viewModel
        }
    }
}

enum RoutingEvent {
    case push(RouterViewModel)
    case pop
}

class Router {

    let latestRoutingEvent: SignalProducer<RoutingEvent, NoError>
    private var viewModelsHistory: [RouterViewModelProtocol]
    private let currentViewModel: MutableProperty<RouterViewModelProtocol?>

    init(entryViewModel: RouterViewModel) {
        self.currentViewModel = MutableProperty(entryViewModel.viewModel)
        self.viewModelsHistory = []

        self.latestRoutingEvent = SignalProducer(value: .push(entryViewModel))

        _ = self.currentViewModel.signal
            .skipNil()
            .flatMap(.latest) { $0.mainActionOutput }
            .on { [unowned self] output in
                guard let currentViewModel = self.currentViewModel.value else { return }
                Router.routing(viewModel: currentViewModel, output: output)
        }

        self.currentViewModel <~ self.latestRoutingEvent
            .repeat(1)
            .on(value: { [unowned self] routingEvent in
                switch routingEvent {
                case .push(let routerViewModel):
                    self.viewModelsHistory += [routerViewModel.viewModel]
                case .pop:
                    self.viewModelsHistory.removeLast(1)
                }
            })
            .map { [unowned self] _ in
                return self.viewModelsHistory.last
        }
    }

    private static func routing(viewModel: RouterViewModelProtocol, output: Any) {
        print("")
        print("")
        print("")
    }
}

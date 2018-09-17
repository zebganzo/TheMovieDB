//
//  PresenterManager.swift
//  TheMovieDB
//
//  Created by Sebastiano Catellani on 16.09.18.
//  Copyright © 2018 Sebastiano Catellani. All rights reserved.
//

import ReactiveSwift
import Result
import UIKit

/// It represents a screen and its view model.
enum ScreenViewModel {
    case movieSearch(MovieSearchProtocol)
    case moviesList(MoviesListProtocol)

    var viewModel: RouterViewModelProtocol {
        switch self {
        case .movieSearch(let viewModel):
            return viewModel
        case .moviesList(let viewModel):
            return viewModel
        }
    }
}

/// The actions that the `PresenterManager` has to handle.
enum PresenterManagerAction {
    case push(RoutingEvent)
    case pop
}

/// Base Protocol of the presenter component.
protocol PresenterManagerProtocol {

    /// It needs to take care of an action.
    func perform(action: PresenterManagerAction)

    /// `rootViewController` of the presenter.
    var rootViewController: UIViewController { get }
}

/// The `PresenterManager` is the component in charge of showing the views to the user.
/// It can be seen as a wrapper arount an instance of a `UINavigationController`,
/// taking care of reflecting on it the routing decisions made by the routing component.
class PresenterManager {

    private let navigationController: UINavigationController
    private let routingManager: RoutingManagerProtocol

    init(navigationController: UINavigationController? = nil, routingManager: RoutingManagerProtocol) {
        self.routingManager = routingManager
        if let navigationController = navigationController {
            self.navigationController = navigationController
        } else {
            self.navigationController = UINavigationController()
        }
    }
}

extension PresenterManager: PresenterManagerProtocol {
    var rootViewController: UIViewController {
        return self.navigationController
    }

    func perform(action: PresenterManagerAction) {

        // The action can be a push or a pop.
        switch action {
        case .push(let routingEvent):
            // In case of a push, it contains a `RoutingEvent` (current view model and its output).
            // It's necessary to ask to the routing manager to determine the new view model
            // and, afterwords, push it in the navigation controller.
            guard let viewModel = self.routingManager.route(with: routingEvent) else {
                assertionFailure("At this point a viewModel should be given, something went wront with \(routingEvent)")
                return
            }
            DispatchQueue.main.async {
                self.navigationController.pushViewController(self.viewController(for: viewModel), animated: true)
            }
        case .pop:
            // Currently, the pop action refletcs a pop operation on the navigation controller.
            DispatchQueue.main.async {
                self.navigationController.popViewController(animated: true)
            }
        }
    }

    /// Given a `ScreenViewModel` (logic representation of a screen plus its view model),
    /// return an instance of a `UIViewController`.
    private func viewController(for screen: ScreenViewModel) -> UIViewController {
        switch screen {
        case .movieSearch(let viewModel):
            return MovieSearchViewController(viewModel: viewModel, presenterManager: self)
        case .moviesList(let viewModel):
            return MoviesListViewController(viewModel: viewModel, presenterManager: self)
        }
    }
}

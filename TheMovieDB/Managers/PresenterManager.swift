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

enum RouterViewModel {
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

enum PresenterManagerAction {
    case push(RoutingEvent)
    case pop
}

protocol PresenterManagerProtocol {
    func perform(action: PresenterManagerAction)
    var rootViewController: UIViewController { get }
}

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
        switch action {
        case .push(let routingEvent):
            guard let viewModel = self.routingManager.route(with: routingEvent) else {
                assertionFailure("At this point a viewModel should be given, something went wront with \(routingEvent)")
                return
            }
            self.navigationController.pushViewController(self.viewController(for: viewModel), animated: true)
        case .pop:
            self.navigationController.popViewController(animated: true)
        }
    }

    private func viewController(for screen: RouterViewModel) -> UIViewController {
        switch screen {
        case .movieSearch(let viewModel):
            return MovieSearchViewController(viewModel: viewModel, presenterManager: self)
        case .moviesList(let viewModel):
            return MoviesListViewController(viewModel: viewModel, presenterManager: self)
        }
    }
}

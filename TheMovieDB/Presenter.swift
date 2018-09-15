//
//  Presenter.swift
//  TheMovieDB
//
//  Created by Sebastiano Catellani on 13.09.18.
//  Copyright © 2018 Sebastiano Catellani. All rights reserved.
//

import ReactiveSwift
import Result
import UIKit

class Presenter {

    private let navigationController: UINavigationController
    private let router: Router

    init(router: Router, navigationController: UINavigationController) {
        self.router = router
        self.navigationController = navigationController

        self.router.latestRoutingEvent
            .observe(on: UIScheduler())
            .on(value: { [unowned self] routerEvent in
                switch routerEvent {
                case .push(let viewModel):
                    self.navigationController.pushViewController(self.viewController(for: viewModel), animated: true)
                case .pop:
                    self.navigationController.popViewController(animated: true)
                }
            })
            .start()
    }

    private func viewController(for screen: RouterViewModel) -> UIViewController {
        switch screen {
        case .movieSearch(let viewModel):
            return MovieSearchViewController(viewModel: viewModel)
        case .moviesList(let viewModel):
            return MoviesListViewController(viewModel: viewModel)
        }
    }
}

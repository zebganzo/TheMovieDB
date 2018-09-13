//
//  MovieSearchViewController.swift
//  TheMovieDB
//
//  Created by Sebastiano Catellani on 13.09.18.
//  Copyright © 2018 Sebastiano Catellani. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import Result

class MovieSearchViewController: UIViewController {

    private let viewModel: MovieSearchViewModel
    private let movieSearchView = MovieSearchView()

    init(viewModel: MovieSearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        self.viewModel.searchAction <~ self.movieSearchView.searchButton.reactive.controlEvents(.touchUpInside)
            .map { [unowned self] _ -> String? in self.movieSearchView.searchTextField.text }
            .skipNil()
            .filter { !$0.isEmpty }

        self.viewModel.searchAction.events.observeResult { result in
            switch result {
            case .success:
                print("Completed!")
            case .failure(let error):
                print("Error \(error.localizedDescription)!")
            }
        }
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = movieSearchView
    }
}

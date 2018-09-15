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

    private let viewModel: MovieSearchProtocol
    private let movieSearchView: MovieSearchView

    init(viewModel: MovieSearchProtocol) {
        self.viewModel = viewModel
        self.movieSearchView = MovieSearchView(loadingSignalProducer: self.viewModel.searchAction.isExecuting.producer)
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        self.viewModel.searchAction <~ self.movieSearchView.headerView.searchTextSignal
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = self.movieSearchView
        self.movieSearchView.tableView.delegate = self
        self.movieSearchView.tableView.dataSource = self
        self.movieSearchView.tableView.register(SuggestionViewCell.self, forCellReuseIdentifier: SuggestionViewCell.defaultCellIdentifier)
    }
}

extension MovieSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: SuggestionViewCell.defaultCellIdentifier, for: indexPath)
        cell.textLabel?.text = "Suggestion"

        return cell
    }
}

extension MovieSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.movieSearchView.headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 140.0
    }
}

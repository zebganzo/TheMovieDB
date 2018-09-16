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

    private var suggestions: [Suggestion] = [] {
        didSet {
            self.movieSearchView.tableView.reloadData()
        }
    }

    init(viewModel: MovieSearchProtocol) {
        self.viewModel = viewModel
        self.movieSearchView = MovieSearchView(loadingSignalProducer: self.viewModel.searchAction.isExecuting.producer)
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        self.viewModel.searchAction <~ self.movieSearchView.headerView.searchTextSignal
        self.viewModel.suggestions
            .producer
            .startWithValues { [weak self] suggestions in
                self?.suggestions = suggestions
        }

        self.viewModel.searchAction.values
            .observe(on: UIScheduler())
            .observeValues { [weak self] searchResult in
                guard let `self` = self else { return }

                let viewModel = MoviesListViewModel(searchResult: searchResult, queryName: "List")
                let viewController = MoviesListViewController(viewModel: viewModel)

                self.navigationController?.pushViewController(viewController, animated: true)
        }

        _ = self.viewModel.searchAction.errors
            .observeValues { error in
                print("Error \(error)")
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
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
        return self.suggestions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SuggestionViewCell.defaultCellIdentifier, for: indexPath)
        cell.textLabel?.text = self.suggestions[indexPath.row]
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
        let suggestion = self.viewModel.suggestions.value[indexPath.row]
        self.viewModel.searchAction.apply(suggestion).start()
    }
}

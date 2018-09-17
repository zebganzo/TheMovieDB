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
    private let presenterManager: PresenterManagerProtocol

    private var suggestions: [Suggestion] = [] {
        didSet {
            DispatchQueue.main.async {
                self.movieSearchView.tableView.reloadData()
            }
        }
    }

    init(viewModel: MovieSearchProtocol, presenterManager: PresenterManagerProtocol) {
        self.viewModel = viewModel
        self.movieSearchView = MovieSearchView(loadingSignalProducer: self.viewModel.searchAction.isExecuting.producer)
        self.presenterManager = presenterManager
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        self.viewModel.searchAction <~ self.movieSearchView.headerView.searchTextSignal

        // Observe "suggestions values" and update the local variable.
        self.viewModel.suggestions
            .producer
            .observe(on: UIScheduler())
            .startWithValues { [weak self] suggestions in
                self?.suggestions = suggestions
        }

        // Observe the values (search result + query) of the `searchAction`
        // and trigger the presenter manager with this value and the current view model.
        self.viewModel.searchAction.values
            .observeValues { [weak self] searchResultAndQuery in
                guard let `self` = self else { return }
                let routingEvent = RoutingEvent.action(.movieSearch(self.viewModel), searchResultAndQuery)
                self.presenterManager.perform(action: .push(routingEvent))
        }

        // Obserse the errors (SearchError) of the `searchAction`.
        _ = self.viewModel.searchAction.errors
            .observeValues { searchError in
                var message: String
                switch searchError {
                case .searchError:
                    message = "An error occured while performing the research"
                case .noMoviesFound:
                    message = "No movies found :-("
                }
                UIAlertController.showAlert(title: "Search error", message: message)
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

        // When a suggestion is selected, it triggers the `searchAction`.
        self.viewModel.searchAction.apply(suggestion).start()
    }
}

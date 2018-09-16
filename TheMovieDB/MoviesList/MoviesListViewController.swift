//
//  MoviesListViewController.swift
//  TheMovieDB
//
//  Created by Sebastiano Catellani on 13.09.18.
//  Copyright © 2018 Sebastiano Catellani. All rights reserved.
//

import UIKit
import ReactiveSwift

protocol UserInteraction { }

enum MoviesListUserInteraction: UserInteraction {
    case back
}

class MoviesListViewController: UIViewController {

    private let viewModel: MoviesListProtocol
    private let moviesListView = MoviesListView()
    private let presenterManager: PresenterManagerProtocol

    init(viewModel: MoviesListProtocol, presenterManager: PresenterManagerProtocol) {
        self.viewModel = viewModel
        self.presenterManager = presenterManager
        super.init(nibName: nil, bundle: nil)
        self.title = self.viewModel.pageName
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = self.moviesListView
        self.moviesListView.tableView.dataSource = self
        self.moviesListView.tableView.delegate = self
        self.moviesListView.tableView.register(UINib(nibName: MovieTableViewCell.defaultNibName, bundle: nil), forCellReuseIdentifier: MovieTableViewCell.defaultCellIdentifier)
        self.moviesListView.tableView.rowHeight = UITableViewAutomaticDimension
        self.moviesListView.tableView.estimatedRowHeight = 260

        self.addCustomBackButton()

        self.viewModel.fetchMoviesSignal
            .observe(on: UIScheduler())
            .observeResult { [weak self] result in
                switch result {
                case .success:
                    self?.moviesListView.tableView.reloadData()
                case .failure(let error):
                    print("Error \(error.localizedDescription)")
                }
        }
    }

    private func addCustomBackButton() {
        self.navigationItem.hidesBackButton = true
        let backButton = UIBarButtonItem(title: "Search", style: UIBarButtonItemStyle.plain, target: self, action: #selector(type(of: self).back(sender:)))
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationController?.navigationBar.tintColor = .black
    }

    @objc func back(sender: UIBarButtonItem) {
        self.presenterManager.perform(action: .pop)
    }
}

extension MoviesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfMovies
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.defaultCellIdentifier, for: indexPath) as? MovieTableViewCell else {
            fatalError("Dequeued wrong type of cell")
        }

        cell.movieBasicInfo = self.viewModel.infoForMovie(at: indexPath.row)

        return cell
    }
}

extension MoviesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewModel.fetchIfNecessary(at: indexPath.row)
    }
}

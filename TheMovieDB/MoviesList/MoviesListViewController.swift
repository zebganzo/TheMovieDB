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

    private let viewModel: MoviesListViewModel
    private let moviesListView = MoviesListView()

    init(viewModel: MoviesListViewModel) {
        self.viewModel = viewModel
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
        self.moviesListView.tableView.register(MovieInfoViewCell.self, forCellReuseIdentifier: MovieInfoViewCell.defaultCellIdentifier)
    }
}

extension MoviesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfMovies
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movieBasicInfo = self.viewModel.infoForMovie(at: indexPath.row)

        let cell = tableView.dequeueReusableCell(withIdentifier: MovieInfoViewCell.defaultCellIdentifier, for: indexPath)

        cell.textLabel?.text = movieBasicInfo.title

        return cell
    }
}

class MovieInfoViewCell: UITableViewCell {

    static let defaultCellIdentifier = "MovieInfoCell"

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

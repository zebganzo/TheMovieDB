//
//  MoviesListViewController.swift
//  TheMovieDB
//
//  Created by Sebastiano Catellani on 13.09.18.
//  Copyright © 2018 Sebastiano Catellani. All rights reserved.
//

import UIKit
import ReactiveSwift

class MoviesListViewController: UIViewController {

    private let viewModel: MoviesListViewModel
    private let moviesListView = MoviesListView()
    private static let cellIdentifier = "MoviwInfoCell"

    init(viewModel: MoviesListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        self.view = self.moviesListView
        self.moviesListView.tableView.dataSource = self
        self.moviesListView.tableView.register(MoviwInfoViewCell.self, forCellReuseIdentifier: type(of: self).cellIdentifier)

    }
}

extension MoviesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfMovies
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Searched name"
        // TODO Film name
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movieBasicInfo = self.viewModel.infoForMoviw(at: indexPath.row)

        let cell = tableView.dequeueReusableCell(withIdentifier: type(of: self).cellIdentifier, for: indexPath)

        cell.textLabel?.text = movieBasicInfo.title

        return cell
    }
}

class MoviwInfoViewCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

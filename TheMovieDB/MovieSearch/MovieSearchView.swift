//
//  MovieSearchView.swift
//  TheMovieDB
//
//  Created by Sebastiano Catellani on 13.09.18.
//  Copyright © 2018 Sebastiano Catellani. All rights reserved.
//

import ReactiveSwift
import Result
import SnapKit
import UIKit

final class MovieSearchView: UIView {

    let headerView: SearchHeaderView
    let tableView = UITableView()

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(loadingSignalProducer: SignalProducer<Bool, NoError>) {
        self.headerView = SearchHeaderView(loadingSignalProducer: loadingSignalProducer)
        super.init(frame: .zero)
        self.backgroundColor = UIColor.white
        self.addSubview(self.tableView)

        self.tableView.snp.makeConstraints { make -> Void in
            make.center.width.height.equalTo(self)
        }
    }
}

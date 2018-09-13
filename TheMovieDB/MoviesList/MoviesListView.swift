//
//  MoviesListView.swift
//  TheMovieDB
//
//  Created by Sebastiano Catellani on 13.09.18.
//  Copyright © 2018 Sebastiano Catellani. All rights reserved.
//

import UIKit
import SnapKit

final class MoviesListView: UIView {

    let tableView = UITableView()

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init() {
        super.init(frame: .zero)
        self.backgroundColor = UIColor.white

        self.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make -> Void in
            make.center.equalTo(self)
            make.top.left.equalTo(self)
        }
    }
}

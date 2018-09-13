//
//  MovieSearchView.swift
//  TheMovieDB
//
//  Created by Sebastiano Catellani on 13.09.18.
//  Copyright © 2018 Sebastiano Catellani. All rights reserved.
//

import UIKit
import SnapKit

final class MovieSearchView: UIView {

    let searchTextField = UITextField()
    let searchButton = UIButton()
    let tableView = UITableView()

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init() {
        super.init(frame: .zero)
        self.backgroundColor = UIColor.white

        self.addSubview(self.searchTextField)
        self.addSubview(self.searchButton)
        self.addSubview(self.tableView)

        self.searchTextField.backgroundColor = UIColor.white
        self.searchTextField.placeholder = "Search a movie..."
        self.searchTextField.snp.makeConstraints { make -> Void in
            make.width.equalTo(self).multipliedBy(0.8)
            make.height.equalTo(50)
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(50)
        }

        self.searchButton.backgroundColor = UIColor.lightGray
        self.searchButton.setTitle("Search", for: .normal)
        self.searchButton.snp.makeConstraints { make -> Void in
            make.width.height.centerX.equalTo(self.searchTextField)
            make.top.equalTo(self.searchTextField.snp.bottom).offset(16)
        }
    }
}

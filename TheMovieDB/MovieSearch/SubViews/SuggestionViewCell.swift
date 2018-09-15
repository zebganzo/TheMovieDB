//
//  SuggestionViewCell.swift
//  TheMovieDB
//
//  Created by Sebastiano Catellani on 15.09.18.
//  Copyright © 2018 Sebastiano Catellani. All rights reserved.
//

import UIKit

class SuggestionViewCell: UITableViewCell {

    static let defaultCellIdentifier = "SuggestionViewCell"

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

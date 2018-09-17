//
//  MovieTableViewCell.swift
//  TheMovieDB
//
//  Created by Sebastiano Catellani on 16.09.18.
//  Copyright © 2018 Sebastiano Catellani. All rights reserved.
//

import UIKit
import SDWebImage

class MovieTableViewCell: UITableViewCell {

    static let defaultCellIdentifier = "MovieTableViewCell"
    static let defaultNibName = "MovieTableViewCell"

    var movieBasicInfo: MovieInfoProtocol? {
        willSet {
            if newValue == nil {
                self.resetUI()
            }
        }
        didSet {
            if let movieBasicInfo = movieBasicInfo {
                self.populateUI(movieBasicInfo: movieBasicInfo)
            }
        }
    }

    @IBOutlet weak var posterImageView: UIImageView! {
        didSet {
            self.posterImageView.sd_setShowActivityIndicatorView(true)
            self.posterImageView.sd_setIndicatorStyle(.gray)
            posterImageView.contentMode = .scaleAspectFit
        }
    }

    @IBOutlet weak var nameLabel: UILabel! {
        didSet {
            nameLabel.textAlignment = .center
        }
    }

    @IBOutlet weak var releaseLabel: UILabel! {
        didSet {
            releaseLabel.textAlignment = .center
        }
    }

    @IBOutlet weak var overviewLabel: UILabel! {
        didSet {
            overviewLabel.textAlignment = .justified
            overviewLabel.numberOfLines = 0
            overviewLabel.lineBreakMode = .byWordWrapping
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        self.selectionStyle = .none

        let internalOffset = 10

        self.nameLabel.snp.makeConstraints { make in
            make.left.top.equalTo(self.contentView).offset(internalOffset)
            make.right.equalTo(self.contentView).inset(internalOffset)
            make.height.equalTo(21)
        }

        self.posterImageView.snp.makeConstraints { make in
            make.left.equalTo(self.contentView).offset(internalOffset)
            make.right.equalTo(self.contentView).inset(internalOffset)
            make.top.equalTo(self.nameLabel.snp.bottom).offset(internalOffset)
            make.height.equalTo(300)
        }

        self.releaseLabel.snp.makeConstraints { make in
            make.left.equalTo(self.contentView).offset(internalOffset)
            make.right.equalTo(self.contentView).inset(internalOffset)
            make.top.equalTo(self.posterImageView.snp.bottom).offset(internalOffset)
            make.height.equalTo(21)
        }

        self.overviewLabel.snp.makeConstraints { make in
            make.left.equalTo(self.contentView).offset(internalOffset)
            make.right.bottom.equalTo(self.contentView).inset(internalOffset)
            make.top.equalTo(self.releaseLabel.snp.bottom).offset(internalOffset)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.movieBasicInfo = nil
    }
}

extension MovieTableViewCell {
    private func resetUI() {
        self.posterImageView.sd_cancelCurrentImageLoad()
        self.posterImageView.image = nil
        self.nameLabel.text = nil
        self.releaseLabel.text = nil
        self.overviewLabel.text = nil
    }

    private func populateUI(movieBasicInfo: MovieInfoProtocol) {
        self.posterImageView.sd_setImage(with: movieBasicInfo.posterURL, completed: nil)
        self.nameLabel.text = movieBasicInfo.title
        self.releaseLabel.text = movieBasicInfo.releaseDate
        self.overviewLabel.text = movieBasicInfo.overview
    }
}

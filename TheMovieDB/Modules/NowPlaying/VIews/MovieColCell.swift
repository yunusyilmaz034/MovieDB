//
//  MovieColCell.swift
//  TheMovieDB
//
//  Created by Yunus Yılmaz on 02.02.23.
//  Copyright © 2021 Challenge. All rights reserved.
//

import UIKit
import Kingfisher

class MovieColCell: UICollectionViewCell {

    static let cellIdentifier = String(describing: MovieColCell.self)
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var raiting: UILabel!

    var movie: Movie? {
        didSet {
            titleLabel.text = movie?.title
            let placeholderImage = UIImage(named: "placeholder")
            if let moviePoster = movie?.posterUrl() {
                posterImage.kf.setImage(with: moviePoster, placeholder: placeholderImage)
            } else {
                posterImage.image = placeholderImage
            }
            raiting.text = movie?.rating.description
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

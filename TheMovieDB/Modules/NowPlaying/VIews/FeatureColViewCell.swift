//
//  FeatureColViewCell.swift
//  TheMovieDB
//
//  Created by Yunus YILMAZ on 14.05.2021.
//  Copyright © 2021 MoviesDB. All rights reserved.
//

import UIKit
import Kingfisher

class FeatureColViewCell: UICollectionViewCell {

    static let cellIdentifier = String(describing: FeatureColViewCell.self)
    @IBOutlet weak var posterImage: UIImageView!

    var movie: Movie? {
        didSet {
            let placeholderImage = UIImage(named: "placeholder")
            if let moviePoster = movie?.posterUrl() {
                posterImage.kf.setImage(with: moviePoster, placeholder: placeholderImage)
            } else {
                posterImage.image = placeholderImage
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

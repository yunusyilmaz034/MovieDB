//
//  MovieDetailViewController.swift
//  TheMovieDB
//
//  Created by Yunus Yılmaz on 02.02.23.
//  Copyright © 2021 Challenge. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    //MARK:- IBOutlet
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewTextView: UITextView!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var favIcon: UIButton!
    
    //MARK:- Variables
    var movie: Movie?
    let persistenceManager: PersistenceManager
    
    //MARK:- View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        setupView()
    }

    init(movie: Movie, persistenceManager: PersistenceManager) {
        self.persistenceManager = persistenceManager
        super.init(nibName: String(describing: MovieDetailViewController.self), bundle: nil)
        self.movie = movie
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK:- Helpers
    func setupView() {
        guard let movie = movie else { return }
        if getFavMovie(movieID: Int64(movie.id)){
            self.favIcon.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            self.favIcon.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        titleLabel.text = movie.title
        overviewTextView.text = movie.overview
        ratingLabel.text = "\(movie.rating)"
        let placeholderImage = UIImage(named: "placeholder")
        if let moviePoster = movie.posterUrl() {
            posterImage.kf.setImage(with: moviePoster, placeholder: placeholderImage)
        } else {
            posterImage.image = placeholderImage
        }
    }

    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func favorite(_ sender: UIButton) {
        guard var movie = movie else { return }
        let isFav = getFavMovie(movieID: Int64(movie.id))
        if isFav {
            let movieFav = MovieFavorite(context: persistenceManager.context)
            movieFav.moveId = Int64(movie.id)
            movieFav.title = movie.title!
            movieFav.overview = movie.overview!
            movieFav.poster = movie.poster!
            movieFav.voteAverage = movie.rating.description
            persistenceManager.delete(movie: movieFav)
            self.favIcon.setImage(UIImage(systemName: "heart"), for: .normal)
        } else {
            saveFavMovie(movie: movie)
            movie.movieFav = true
            self.favIcon.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
    }
    func getFavMovie(movieID: Int64) -> (Bool) {
        guard let favMovie = try! persistenceManager.context.fetch(MovieFavorite.fetchRequest()) as? [MovieFavorite] else {return false}
        for movi in favMovie {
            if movi.moveId == movieID {
                print("saved movie \(movi.title!)")
                return true
            }
        }
        return false
    }
    func saveFavMovie(movie: Movie?) {
        if let mv = movie {
            let movieFav = MovieFavorite(context: persistenceManager.context)
            movieFav.moveId = Int64(mv.id)
            movieFav.title = mv.title!
            movieFav.overview = mv.overview!
            movieFav.poster = mv.poster!
            movieFav.voteAverage = mv.rating.description
            try! persistenceManager.save()
        }
    }
}

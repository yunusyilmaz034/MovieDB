//
//  MovieFavoritesViewController.swift
//  TheMovieDB
//
//  Created by Yunus YILMAZ on 16.05.2021.
//  Copyright © 2021 MoviesDB. All rights reserved.
//

import UIKit

class MovieFavoritesViewController: UIViewController {
    
    //MARK:- IBOutlet
    @IBOutlet weak var colView: UICollectionView!
    @IBOutlet weak var tabbar: UITabBar!
    
    //MARK:- Variables
    var movie: [Movie]?
    var coordinatorDelegate: MovieFavoritesCoordinator?
    let persistenceManager: PersistenceManager
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        setupView()
    }
    init(persistenceManager: PersistenceManager, favMovies: [Movie]) {
        self.persistenceManager = persistenceManager
        super.init(nibName: String(describing: MovieFavoritesViewController.self), bundle: nil)
        self.movie = favMovies
    }
    override func viewDidAppear(_ animated: Bool) {
        if movie?.count != getFavMoviesCount() {
            tabbar.items?[1].badgeValue = changeFavMovies().description
            colView.reloadData()
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK:- Helpers
    func setupView() {
        tabbar.selectedItem = tabbar.items?[1]
        tabbar.items?[1].badgeValue = movie?.count.description
        colView.register(UINib(nibName: MovieColCell.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: MovieColCell.cellIdentifier)
    }
    
    @IBAction func back(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}
// MARK: UICollectionViewDataSource

extension MovieFavoritesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movie?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = colView.dequeueReusableCell(withReuseIdentifier: MovieColCell.cellIdentifier, for: indexPath) as? MovieColCell  {
            cell.movie = movie?[indexPath.row]
            return cell
        }
        return UICollectionViewCell()
    }
    // MARK: UICollectionViewDelegate
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        colView.deselectItem(at: indexPath, animated: true)
        let movie = self.movie![indexPath.row]
        coordinatorDelegate?.movieSelected(movie: movie)
    }
}
//MARK: UICollectionViewDelegateFlowLayout
extension MovieFavoritesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 414, height: 169) // default MovieCol Cell
    }
    
}
//MARK: - Core DATA
extension MovieFavoritesViewController {
    func getFavMoviesCount() -> Int {
        guard let favMovie = try! persistenceManager.context.fetch(MovieFavorite.fetchRequest()) as? [MovieFavorite] else {return 0}
        return favMovie.count
    }
    func changeFavMovies() -> Int {
        guard let favMovie = try! persistenceManager.context.fetch(MovieFavorite.fetchRequest()) as? [MovieFavorite] else {return 0}
        self.movie?.removeAll()
        var count = 0
        for movi in favMovie {
            if count == 0 {
                self.movie = [Movie(id: Int(movi.moveId), title: movi.title!, overview: movi.overview!, poster: movi.poster!, voteAverage: Decimal(string: movi.voteAverage!)!)]
            } else {
                self.movie?.append(Movie(id: Int(movi.moveId), title: movi.title!, overview: movi.overview!, poster: movi.poster!, voteAverage: Decimal(string: movi.voteAverage!)!))
            }
            count += 1
        }
        return count
    }
}
//MARK:- UITabBarDelegate
extension MovieFavoritesViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 0 {
            tabbar.selectedItem = tabbar.items?.first
            self.navigationController?.popViewController(animated: true)            
        }
    }
}

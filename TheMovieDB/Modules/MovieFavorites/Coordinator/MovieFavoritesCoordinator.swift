import Foundation
import UIKit

class MovieFavoritesCoordinator: Coordinator {
    //MARK:- Variables
    var navigationController: UINavigationController
    var favMovies: [Movie]
    var delegate: MovieFavoritesCoordinator?
    var persistenceManager: PersistenceManager?
    
    //MARK:- Init
    init(navigationController: UINavigationController, favMovies: [Movie]) {
        self.navigationController = navigationController
        self.navigationController.navigationBar.tintColor = UIColor.black
        self.favMovies = favMovies
    }

    //MARK:- Helpers
    func getViewController(persistenceManager: PersistenceManager) -> UIViewController {
        self.persistenceManager = persistenceManager
        let movieFavoriteViewController = MovieFavoritesViewController(persistenceManager: persistenceManager, favMovies: self.favMovies)
        movieFavoriteViewController.coordinatorDelegate = self
        return movieFavoriteViewController
    }

    func show(present: Bool = false, persistenceManager: PersistenceManager) {
        let movieFavoritesViewController = getViewController(persistenceManager: persistenceManager)
        if present {
            movieFavoritesViewController.modalTransitionStyle = .crossDissolve
            self.navigationController.viewControllers.last?.present(movieFavoritesViewController, animated: true, completion: nil)
        } else {
            self.navigationController.navigationBar.prefersLargeTitles = true
            self.navigationController.pushViewController(movieFavoritesViewController, animated: true)
        }
    }
    func movieSelected(movie: Movie) {
        MovieDetailCoordinator(navigationController: self.navigationController, movie: movie).show(persistenceManager: self.persistenceManager!)
    }
}

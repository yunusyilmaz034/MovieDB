//
//  MovieDetailCoordinator.swift
//  TheMovieDB
//
//  Created by Yunus Yılmaz on 02.02.23.
//  Copyright © 2021 Challenge. All rights reserved.
//

import Foundation
import UIKit

class MovieDetailCoordinator: Coordinator {
    //MARK:- Variables
    var navigationController: UINavigationController
    var movie: Movie

    //MARK:- Init
    init(navigationController: UINavigationController, movie: Movie) {
        self.navigationController = navigationController
        self.navigationController.navigationBar.tintColor = UIColor.black
        self.movie = movie
    }

    //MARK:- Helpers
    func getViewController(persistenceManager: PersistenceManager) -> UIViewController {
        return MovieDetailViewController(movie: movie, persistenceManager: persistenceManager)
    }

    func show(present: Bool = false, persistenceManager: PersistenceManager) {
        let movieDetailViewController = getViewController(persistenceManager: persistenceManager)
        if present {
            movieDetailViewController.modalTransitionStyle = .crossDissolve
            self.navigationController.viewControllers.last?.present(movieDetailViewController, animated: true, completion: nil)
        } else {
            self.navigationController.navigationBar.prefersLargeTitles = true
            self.navigationController.pushViewController(movieDetailViewController, animated: true)
        }
    }
}

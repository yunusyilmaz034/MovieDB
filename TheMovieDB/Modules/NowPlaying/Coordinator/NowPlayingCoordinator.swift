//
//  NowPlayingCoordinator.swift
//  TheMovieDB
//
//  Created by Yunus Yılmaz on 02.02.23.
//  Copyright © 2021 Challenge. All rights reserved.
//

import UIKit
import Foundation

protocol NowPlayingCoordinatorDelegate {
    func movieSelected(movie: Movie)
    func tabFavSelected(movies: [Movie])
}

class NowPlayingCoordinator: Coordinator {
    //MARK:- Variables
    var navigationController: UINavigationController
    var nowPlayingViewModel = NowPlayingViewModel()
    var searchViewModel = SearchViewModel()
    var delegate: NowPlayingCoordinatorDelegate?
    var persistenceManager: PersistenceManager?
    //MARK:- Init
     init(navigationController: UINavigationController) {
         self.navigationController = navigationController
     }

    //MARK:- Helpers
    func getViewController(persistenceManager: PersistenceManager) -> UIViewController {
        let colViewController = NowPlayingColViewController(viewModel: nowPlayingViewModel, searchViewModel: searchViewModel, persistenceManager: persistenceManager)
        self.persistenceManager = persistenceManager
        colViewController.coordinatorDelegate = self
        return colViewController
    }

    func show(present: Bool = false, persistenceManager: PersistenceManager) {
        let nowPlayingViewController = getViewController(persistenceManager: persistenceManager)
        if present {
            nowPlayingViewController.modalTransitionStyle = .crossDissolve
            self.navigationController.viewControllers.last?.present(nowPlayingViewController, animated: true, completion: nil)
        } else {
            self.navigationController.navigationBar.prefersLargeTitles = true
            self.navigationController.pushViewController(nowPlayingViewController, animated: true)
        }
    }
}

extension NowPlayingCoordinator: NowPlayingCoordinatorDelegate {
    func movieSelected(movie: Movie) {
        MovieDetailCoordinator(navigationController: self.navigationController, movie: movie).show(persistenceManager: self.persistenceManager!)
    }
    func tabFavSelected(movies: [Movie]) {
        MovieFavoritesCoordinator(navigationController: self.navigationController, favMovies: movies).show(persistenceManager: self.persistenceManager!)
    }
}

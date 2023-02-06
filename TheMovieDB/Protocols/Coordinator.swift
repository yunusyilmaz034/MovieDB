//
//  Coordinator.swift
//  TheMovieDB
//
//  Created by Yunus Yılmaz on 01.02.23.
//  Copyright © 2021 Challenge. All rights reserved.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func getViewController(persistenceManager: PersistenceManager) -> UIViewController
    func show(present: Bool, persistenceManager: PersistenceManager)
}

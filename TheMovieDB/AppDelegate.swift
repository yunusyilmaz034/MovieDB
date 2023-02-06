//
//  AppDelegate.swift
//  TheMovieDB
//
//  Created by Yunus Yılmaz on 01.02.23.
//  Copyright © 2021 Challenge. All rights reserved.
//

import UIKit
import CoreData
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var nowPlayingCoordinator: NowPlayingCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        nowPlayingCoordinator = NowPlayingCoordinator(navigationController: UINavigationController())
        nowPlayingCoordinator?.show(persistenceManager: PersistenceManager.shared)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = nowPlayingCoordinator?.navigationController
        window?.makeKeyAndVisible()
        return true
    }
}

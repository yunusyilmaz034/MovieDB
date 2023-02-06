//
//  PersistenceManager.swift
//  TheMovieDB
//
//  Created by Yunus Yılmaz on 02.02.23.
//  Copyright © 2021 Challenge. All rights reserved.
//

import Foundation
import CoreData

final class PersistenceManager {
    private init() {}
    static let shared = PersistenceManager()
    
    //MARK: - Core Data Stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FavoriteMovie")
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
            return container
        }()
    lazy var context = persistentContainer.viewContext
    
        // MARK: - Core Data Saving support
        
        func save () {
            let context = persistentContainer.viewContext
            if context.hasChanges {
                do {
                    try context.save()
                    print("saved successfully")
                } catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
    func delete(movie: MovieFavorite) -> Bool {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieFavorite")

         let result = try? context.fetch(fetchRequest)
            let resultData = result as! [MovieFavorite]

            for object in resultData {
                if object.moveId == movie.moveId {
                    context.delete(object)
                }
            }

            do {
                try context.save()
                print("saved!")
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            } catch {

            }
        return true
    }
}

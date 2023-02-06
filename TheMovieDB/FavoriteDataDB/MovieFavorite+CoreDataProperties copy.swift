//
//  MovieFavorite+CoreDataProperties.swift
//  
//
//  Created by Yunus YILMAZ on 16.05.2021.
//
//

import Foundation
import CoreData


extension MovieFavorite {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieFavorite> {
        return NSFetchRequest<MovieFavorite>(entityName: "MovieFavorite")
    }

    @NSManaged public var moveId: Int64
    @NSManaged public var title: String?
    @NSManaged public var overview: String?
    @NSManaged public var poster: String?
    @NSManaged public var voteAverage: String?

}

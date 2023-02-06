//
//  Movie.swift
//  TheMovieDB
//
//  Created by Yunus Yılmaz on 02.02.23.
//  Copyright © 2021 Challenge. All rights reserved.
//

import Foundation

struct Movie: Codable {

    var id: Int
    var title: String?
    var overview: String?
    var poster: String?
    private var voteAverage: Decimal
    var rating: NSDecimalNumber {
        get { return NSDecimalNumber(decimal: voteAverage) }
    }
    var movieFav: Bool?
    
    init(id: Int, title: String, overview: String, poster: String, voteAverage: Decimal) {
        self.id = id
        self.title = title
        self.overview = overview
        self.poster = poster
        self.voteAverage = voteAverage
    }

    func posterUrl() -> URL? {
        return URL(string: "\(NetworkConstants.imagesBaseURL)\(poster ?? "")")
    }

    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case poster = "poster_path"
        case voteAverage = "vote_average"
    }
}

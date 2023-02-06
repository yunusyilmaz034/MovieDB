//
//  SearchResponse.swift
//  TheMovieDB
//
//  Created by Yunus Yılmaz on 02.02.23.
//  Copyright © 2021 Challenge. All rights reserved.
//

import Foundation

struct SearchResponse: Codable {
    var movies: [Movie]
    var page: Int
    var totalPages: Int

    enum CodingKeys: String, CodingKey {
        case page
        case movies = "results"
        case totalPages = "total_pages"
    }
}

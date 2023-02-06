//
//  NetworkConstants.swift
//  TheMovieDB
//
//  Created by Yunus Yılmaz on 02.02.23.
//  Copyright © 2021 Challenge. All rights reserved.
//

import Foundation

struct NetworkConstants {
    static let defaultRequestParams = ["api_key": "fd2b04342048fa2d5f728561866ad52a"]
    static let defaultRequestHeaders = ["Content-type": "application/json; charset=utf-8"]
    static let baseURL = "https://api.themoviedb.org/3"
    static let nowPlayingServicePath = "/movie/now_playing"
    static let searchServicePath = "/search/movie"
    static let imagesBaseURL = "https://image.tmdb.org/t/p/w500/"
    static let queryParameterKey = "query"
    static let pageParameterKey = "page"
}

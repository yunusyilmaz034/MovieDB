//
//  Mock.swift
//  TheMovieDBTests
//
//  Created by Yunus Yılmaz on 02.02.23.
//  Copyright © 2021 Challenge. All rights reserved.
//

import Foundation
@testable import TheMovieDB

internal extension Movie {
    static func getMockMovie() -> Movie {
        return Movie(id: 1, title: "Titanic", overview: "Overview text", poster: "1.jpg", voteAverage: 8.7)
    }
}

internal extension NowPlayingResponse {
    static func getMockNowPlayingResponse () -> NowPlayingResponse {
        return NowPlayingResponse(movies: [Movie.getMockMovie()], totalPages: 1)
    }
}

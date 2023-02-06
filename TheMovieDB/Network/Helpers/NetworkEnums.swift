//
//  NetworkEnums.swift
//  TheMovieDB
//
//  Created by Yunus Yılmaz on 01.02.23.
//  Copyright © 2021 Challenge. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get    = "GET"
    case post   = "POST"
    case put    = "PUT"
    case delete = "DELETE"
}

enum Task {
    case requestPlain
    case requestParameters([String: String])
}

enum ParametersEncoding {
    case url
    case json
}

enum APIResponse<T> {
    case success(T)
    case failure(NetworkError)
}

enum NetworkError {
    case unauthorized
    case unknown
    case noJSONData
    case JSONDecoder
}

enum FetchingServiceState: Equatable {
    case loading
    case finishedLoading
    case error(NetworkError?)
}

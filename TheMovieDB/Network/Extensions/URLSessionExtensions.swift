//
//  URLSessionExtensions.swift
//  TheMovieDB
//
//  Created by Yunus Yılmaz on 01.02.23.
//  Copyright © 2021 Challenge. All rights reserved.
//

import Foundation

extension URLSession: URLSessionProtocol {
    func dataTask(request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTask {
        return dataTask(with: request, completionHandler: completionHandler)
    }
}

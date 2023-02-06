//
//  SearchAPI.swift
//  TheMovieDB
//
//  Created by Yunus Yılmaz on 02.02.23.
//  Copyright © 2021 Challenge. All rights reserved.
//

import Foundation

class SearchAPI: Service {

    var paramters: [String: String]?

    init(paramters: [String: String]?) {
        self.paramters = paramters
        self.paramters?.append(dict: NetworkConstants.defaultRequestParams)
    }

    var baseURL: URL {
        return URL(string: NetworkConstants.baseURL)!
    }

    var path: String {
        return NetworkConstants.searchServicePath
    }

    var method: HTTPMethod {
        return .get
    }

    var task: Task {
        return .requestParameters(self.paramters ?? [:])
    }

    var headers: RequestHeaders? {
        return NetworkConstants.defaultRequestHeaders
    }

    var parametersEncoding: ParametersEncoding {
        return .url
    }
}

protocol SearchAPIService {
    func searchMovies(service: Service, completion: @escaping (_ result: APIResponse<SearchResponse>) -> ())
}

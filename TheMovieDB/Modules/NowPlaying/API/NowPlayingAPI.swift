//
//  NowPlayingAPI.swift
//  TheMovieDB
//
//  Created by Yunus Yılmaz on 01.02.23.
//  Copyright © 2021 Challenge. All rights reserved.
//

import Foundation

class NowPlayingAPI: Service {

    var paramters: [String: String]?

    init(paramters: [String: String]?) {
        self.paramters = paramters
        self.paramters?.append(dict: NetworkConstants.defaultRequestParams)
    }

    var baseURL: URL {
        return URL(string: NetworkConstants.baseURL)!
    }

    var path: String {
        return NetworkConstants.nowPlayingServicePath
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

protocol NowPlayingAPIService {
    func getNowPlayingMovies(service: Service, completion: @escaping (_ result: APIResponse<NowPlayingResponse>) -> ())
}

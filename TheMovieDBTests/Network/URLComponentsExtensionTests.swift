//
//  URLComponentsExtensionTests.swift
//  TheMovieDBTests
//
//  Created by Yunus Yılmaz on 02.02.23.
//  Copyright © 2021 Challenge. All rights reserved.
//

import XCTest
import Foundation
@testable import TheMovieDB

class URLComponentsExtensionTests: XCTestCase {
    
    func testInit() {
        let parameters = ["MockParamter": "value"]
        let mockService = MockService(paramters: parameters)
        let urlComponents = URLComponents(service: mockService)
        XCTAssertEqual(urlComponents.queryItems?.first?.name, parameters.keys.first)
        XCTAssertEqual(urlComponents.queryItems?.first?.value, parameters.values.first)
        let urlStringWithParmaters = "https://MockService/ios?MockParamter=value"
        XCTAssertEqual(urlComponents.url?.absoluteString, urlStringWithParmaters)
    }
}

final class MockService: Service {

    var paramters: [String: String]?

    init(paramters: [String: String]?) {
        self.paramters = paramters
    }

    var baseURL: URL {
        return URL(string: "https://MockService")!
    }

    var path: String {
        return "ios"
    }

    var method: HTTPMethod {
        return .get
    }

    var task: Task {
        return .requestParameters(self.paramters ?? [:])
    }

    var headers: RequestHeaders? {
        return ["mockHeader": "value"]
    }

    var parametersEncoding: ParametersEncoding {
        return .url
    }
}

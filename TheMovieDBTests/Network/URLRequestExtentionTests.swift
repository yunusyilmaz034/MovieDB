//
//  URLRequestExtentionTests.swift
//  TheMovieDBTests
//
//  Created by Yunus Yılmaz on 02.02.23.
//  Copyright © 2021 Challenge. All rights reserved.
//

import Foundation
import XCTest
@testable import TheMovieDB

class URLRequestExtentionTests: XCTestCase {
    
    func testInit() {
        let parameters = ["MockParamter": "value"]
        let mockService = MockService(paramters: parameters)
        let urlRequest = URLRequest(service: mockService)
        let urlStringWithParmaters = "https://MockService/ios?MockParamter=value"
        XCTAssertEqual(urlRequest.allHTTPHeaderFields?.first?.key, mockService.headers?.keys.first)
        XCTAssertEqual(urlRequest.allHTTPHeaderFields?.first?.value, mockService.headers?.values.first)
        XCTAssertEqual(urlRequest.httpMethod, mockService.method.rawValue)
        XCTAssertEqual(urlRequest.url?.absoluteString, urlStringWithParmaters)
    }
}

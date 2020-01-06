//
//  JeopardyGameTests.swift
//  JeopardyGameTests
//
//  Created by MCS on 1/6/20.
//  Copyright © 2020 PaulRenfrew. All rights reserved.
//

import XCTest

class JeopardyGameTests: XCTestCase {
    
    ///This is the API URL
    /// http://jservice.io/api/clues
    ///just leaving it here for further references
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    func testSample(){
        let expected = 0
        var current = 0
        guard let theURL = URL(string: "http://jservice.io/api/clues") else {
            XCTAssert(false)
            return
        }
        URLSession.shared.dataTask(with: theURL) {[weak self] (data, _, error) in
            guard let data = data else {
                XCTAssert(false)
                return
            }
            print("the data is \(data)")
            current.self = data.count
        }.resume()
        XCTAssertGreaterThan(current, expected)
    }
}

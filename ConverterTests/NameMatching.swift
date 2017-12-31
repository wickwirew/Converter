//
//  NameMatching.swift
//  ConverterTests
//
//  Created by Wes Wickwire on 12/30/17.
//  Copyright © 2017 weswickwire. All rights reserved.
//

import XCTest
@testable import Converter


class NameMatching: XCTestCase {
    
    func testToPascal() {
        let name = ["some", "property", "name"]
        let pascal = toPascalCasing(words: name)
        XCTAssert(pascal == "SomePropertyName")
    }
    
    func testToSnake() {
        let name = ["some", "property", "name"]
        let snake = toSnakeCasing(words: name)
        XCTAssert(snake == "some_property_name")
    }
    
    func testToCamelCasing() {
        let name = ["some", "property", "name"]
        let snake = toCamelCasing(words: name)
        XCTAssert(snake == "somePropertyName")
    }
    
    func testWords() {
        let name = "somePropertyName"
        let w = words(from: name)
        XCTAssert(w.count == 3)
        XCTAssert(w[0] == "some")
        XCTAssert(w[1] == "property")
        XCTAssert(w[2] == "name")
    }
    
    func testWords2() {
        let name = "someProperty_Name"
        let w = words(from: name)
        XCTAssert(w.count == 3)
        XCTAssert(w[0] == "some")
        XCTAssert(w[1] == "property")
        XCTAssert(w[2] == "name")
    }
    
    func testWords3() {
        let name = "some_property_name"
        let w = words(from: name)
        XCTAssert(w.count == 3)
        XCTAssert(w[0] == "some")
        XCTAssert(w[1] == "property")
        XCTAssert(w[2] == "name")
    }
    
    func testWords4() {
        let name = "SomePropertyName"
        let w = words(from: name)
        XCTAssert(w.count == 3)
        XCTAssert(w[0] == "some")
        XCTAssert(w[1] == "property")
        XCTAssert(w[2] == "name")
    }
    
}

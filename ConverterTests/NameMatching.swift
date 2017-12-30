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
        let name = "somePropertyName"
        let pascal = toPascalCasing(value: name)
        XCTAssert(pascal == "SomePropertyName")
    }
    
    func testToSnake() {
        let name = "somePropertyName"
        let snake = toSnakeCasing(value: name)
        XCTAssert(snake == "some_property_name")
    }
    
}

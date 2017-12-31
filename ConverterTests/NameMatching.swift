// MIT License
//
// Copyright (c) 2017 Wesley Wickwire
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

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

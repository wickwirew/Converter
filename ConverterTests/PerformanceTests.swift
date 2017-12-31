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
import Runtime
@testable import Converter


class PerformanceTests: XCTestCase {
    
    
    func testMapping() throws {
        try! createConversion(from: A.self, to: B.self)
        let source = A(a: 1, b: 2, c: 3, d: 4, e: 5, f: 6, g: 7, h: 8, i: 9)
        measure {
            for _ in 0 ..< 100 {
                let _ = try! Converter.convert(source, to: B.self)
            }
        }
    }
    
    func testNoMapping() throws {
        let source = A(a: 1, b: 2, c: 3, d: 4, e: 5, f: 6, g: 7, h: 8, i: 9)
        measure {
            for _ in 0 ..< 100 {
                let _ = try! map(source, to: B.self)
            }
        }
    }
}


fileprivate func map<Source, Destination>(_ source: Source, to destination: Destination.Type) throws -> Destination {
    
    let sourceProperties = try typeInfo(of: Source.self).properties
    let destinationProperties = try typeInfo(of: Destination.self).properties
    
    var result: Destination = try createInstance()
    
    for sourceProperty in sourceProperties {
        if let destinationProperty = destinationProperties.first(where: { $0.name == sourceProperty.name }) {
            
            let typesEqual = isType(sourceProperty.type, equalTo: destinationProperty.type)
            
            if typesEqual {
                let value = try sourceProperty.get(from: source)
                try destinationProperty.set(value: value, on: &result)
            } else {
                let value = try sourceProperty.get(from: source)
                let converted = try Converter.convert(value, to: destinationProperty.type)
                try destinationProperty.set(value: converted, on: &result)
            }
        }
    }
    
    return result
}



struct A {
    var a,b,c,d,e,f,g,h,i: Int
}

struct B {
    var a,b,c,d,e,f,g,h,i: Int
}




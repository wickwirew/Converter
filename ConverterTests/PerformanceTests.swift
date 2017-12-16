//
//  PerformanceTests.swift
//  ConverterTests
//
//  Created by Wes Wickwire on 12/8/17.
//  Copyright © 2017 weswickwire. All rights reserved.
//

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




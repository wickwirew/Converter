//
//  DeflationObjectTests.swift
//  ConverterTests
//
//  Created by Wes Wickwire on 1/3/18.
//  Copyright © 2018 weswickwire. All rights reserved.
//

import XCTest
@testable import Converter


class DelfationTests: XCTestCase {

    func testDeflation() throws {
        
        struct Nested {
            var name: String
        }
        
        struct Source {
            var nested: Nested
        }
        
        struct Destination {
            var nestedName: String
        }
        
        try createConversion(from: Source.self, to: Destination.self)
        
        let source = Source(nested: Nested(name: "it worked!"))
        let converted: Destination = try convert(source)
        XCTAssert(converted.nestedName == source.nested.name)
    }
    
    func testDelfationWhenSourcePropertyExistsDirectly() throws {
        
        struct Nested {
            var name: String
        }
        
        struct Source {
            var nestedName: String
            var nested: Nested
        }
        
        struct Destination {
            var nestedName: String
        }
        
        try createConversion(from: Source.self, to: Destination.self)
        
        let source = Source(nestedName: "it worked!", nested: Nested(name: "it didnt work"))
        let converted: Destination = try convert(source)
        XCTAssert(converted.nestedName == source.nestedName)
    }

}


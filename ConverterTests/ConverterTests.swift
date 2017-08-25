//
//  ConverterTests.swift
//  ConverterTests
//
//  Created by Wes on 8/24/17.
//  Copyright © 2017 weswickwire. All rights reserved.
//

import XCTest
@testable import Converter

class ConverterTests: XCTestCase {
    
    func testCreateConversion() {
        
    }
    
}

fileprivate struct Person {
    var id: Int
    var firstName: String
    var lastName: String
    var age: Int
}

fileprivate struct PersonMinimal {
    var firstName: String
    var lastName: String
}

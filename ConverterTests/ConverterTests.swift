//
//  ConverterTests.swift
//  ConverterTests
//
//  Created by Wes on 8/24/17.
//  Copyright © 2017 weswickwire. All rights reserved.
//

import XCTest
import Runtime
@testable import Converter

class ConverterTests: XCTestCase {
    
    func testCreateConversion() {
        try? Conversion.create(from: Person.self, to: PersonMinimal.self)
        let wes = Person(id: 3, firstName: "Wes", lastName: "Wickwire", age: 25)
        let mini = try? Converter.convert(wes, to: PersonMinimal.self)
        print(mini)
    }
    
    
    func testConversion() {
        try? Conversion.create(from: Engine.self, to: EngineMinimal.self)
        try? Conversion.create(from: Car.self, to: CarMinimal.self)
        let s2k = Car(id: 3, make: "Honda", model: "S2000", engine: Engine(horsePower: 245, serialNumber: "34254352"))
        let mini: CarMinimal = try! Converter.convert(s2k)
        
        XCTAssert(mini.make == "Honda")
        XCTAssert(mini.model == "S2000")
        XCTAssert(mini.engine.horsePower == 245)
    }
    
}

fileprivate struct Person {
    var id: Int = 0
    var firstName: String = ""
    var lastName: String = ""
    var age: Int = 0
}

fileprivate struct PersonMinimal {
    var firstName: String = ""
    var lastName: String = ""
}


fileprivate struct Car: DefaultConstructor {
    var id: Int = 0
    var make: String = ""
    var model: String = ""
    var engine: Engine = Engine()
    init() {}
    init(id: Int, make: String, model: String, engine: Engine) {
        self.id = id
        self.make = make
        self.model = model
        self.engine = engine
    }
}

fileprivate struct CarMinimal: DefaultConstructor {
    var make: String = ""
    var model: String = ""
    var engine: EngineMinimal = EngineMinimal()
    init() {}
}

fileprivate struct Engine: DefaultConstructor {
    var horsePower: Int = 0
    var serialNumber: String = ""
    init() {}
    init(horsePower: Int, serialNumber: String) {
        self.horsePower = horsePower
        self.serialNumber = serialNumber
    }
}

fileprivate struct EngineMinimal {
    var horsePower: Int = 0
}

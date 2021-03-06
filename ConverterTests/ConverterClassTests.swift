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


class ConverterClassTests: XCTestCase {
    
    func testConversion() {
        try! createConversion(from: Person.self, to: PersonMinimal.self)
        let wes = Person(id: 3, firstName: "Wes", lastName: "Wickwire", age: 25)
        let mini: PersonMinimal = try! convert(wes)
        
        XCTAssert(mini.firstName == "Wes")
        XCTAssert(mini.lastName == "Wickwire")
    }
    
    func testConversion_DesintationUntyped() {
        try! createConversion(from: Person.self, to: PersonMinimal.self)
        let wes = Person(id: 3, firstName: "Wes", lastName: "Wickwire", age: 25)
        let mini = try! convert(wes, to: PersonMinimal.self)
        
        XCTAssert((mini as! PersonMinimal).firstName == "Wes")
        XCTAssert((mini as! PersonMinimal).lastName == "Wickwire")
    }
    
    func testConversion_SourceUntyped() {
        try! createConversion(from: Person.self, to: PersonMinimal.self)
        let wes: Any = Person(id: 3, firstName: "Wes", lastName: "Wickwire", age: 25)
        let mini: PersonMinimal = try! convert(wes)
        
        XCTAssert(mini.firstName == "Wes")
        XCTAssert(mini.lastName == "Wickwire")
    }
    
    func testConversion_Untyped() {
        try! createConversion(from: Person.self, to: PersonMinimal.self)
        let wes: Any = Person(id: 3, firstName: "Wes", lastName: "Wickwire", age: 25)
        let mini = try! convert(wes, to: PersonMinimal.self)
        
        XCTAssert((mini as! PersonMinimal).firstName == "Wes")
        XCTAssert((mini as! PersonMinimal).lastName == "Wickwire")
    }
    
    func testConversion_Nested() {
        try! createConversion(from: Engine.self, to: EngineMinimal.self)
        try! createConversion(from: Car.self, to: CarMinimal.self)
        
        let s2k = Car(id: 3, make: "Honda", model: "S2000", engine: Engine(horsePower: 245, serialNumber: "34254352"))
        let mini: CarMinimal = try! convert(s2k)
        
        XCTAssert(mini.make == "Honda")
        XCTAssert(mini.model == "S2000")
        XCTAssert(mini.engine.horsePower == 245)
    }
    
    func testConversion_Nested_DestinationUntyped() {
        try! createConversion(from: Engine.self, to: EngineMinimal.self)
        try! createConversion(from: Car.self, to: CarMinimal.self)
        
        let s2k = Car(id: 3, make: "Honda", model: "S2000", engine: Engine(horsePower: 245, serialNumber: "34254352"))
        let mini = try! convert(s2k, to: CarMinimal.self)
        
        XCTAssert((mini as! CarMinimal).make == "Honda")
        XCTAssert((mini as! CarMinimal).model == "S2000")
        XCTAssert((mini as! CarMinimal).engine.horsePower == 245)
    }
    
    func testConversion_Nested_SourceUntyped() {
        try! createConversion(from: Engine.self, to: EngineMinimal.self)
        try! createConversion(from: Car.self, to: CarMinimal.self)
        
        let s2k: Any = Car(id: 3, make: "Honda", model: "S2000", engine: Engine(horsePower: 245, serialNumber: "34254352"))
        let mini: CarMinimal = try! convert(s2k)
        
        XCTAssert(mini.make == "Honda")
        XCTAssert(mini.model == "S2000")
        XCTAssert(mini.engine.horsePower == 245)
    }
    
    func testConversion_Nested_Untyped() {
        try! createConversion(from: Engine.self, to: EngineMinimal.self)
        try! createConversion(from: Car.self, to: CarMinimal.self)
        
        let s2k = Car(id: 3, make: "Honda", model: "S2000", engine: Engine(horsePower: 245, serialNumber: "34254352"))
        let mini = try! convert(s2k, to: CarMinimal.self)
        
        XCTAssert((mini as! CarMinimal).make == "Honda")
        XCTAssert((mini as! CarMinimal).model == "S2000")
        XCTAssert((mini as! CarMinimal).engine.horsePower == 245)
    }
    
    func testConversionCustomMapping() {
        try! createConversion(from: Person.self, to: Teacher.self)
            .for(property: "name", use: {"\($0.firstName) \($0.lastName)"})
        
        let person = Person(id: 7, firstName: "Wes", lastName: "Wickwire", age: 25)
        
        let teacher: Teacher = try! Converter.convert(person)
        
        XCTAssert(teacher.name == "Wes Wickwire")
        XCTAssert(teacher.age == 25)
    }
    
    func testIgnore() {
        try! createConversion(from: Person.self, to: PersonMinimal.self)
            .ignore(property: "lastName")
        
        let source = Person(id: 8, firstName: "Wes", lastName: "Wickwire", age: 25)
        let mini: PersonMinimal = try! convert(source)
        
        XCTAssert(mini.firstName == "Wes")
        XCTAssert(mini.lastName == "")
    }
}

fileprivate class Person {
    var id: Int = 0
    var firstName: String = ""
    var lastName: String = ""
    var age: Int = 0
    required init() {}
    init(id: Int, firstName: String, lastName: String, age: Int) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
}

fileprivate class PersonMinimal {
    var firstName: String = ""
    var lastName: String = ""
    required init() {}
    init(firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
    }
}

fileprivate class Teacher {
    var name: String = ""
    var age: Int = 0
    required init() {}
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}

fileprivate class Car {
    var id: Int = 0
    var make: String = ""
    var model: String = ""
    var engine: Engine = Engine()
    required init() {}
    init(id: Int, make: String, model: String, engine: Engine) {
        self.id = id
        self.make = make
        self.model = model
        self.engine = engine
    }
}

fileprivate class CarMinimal {
    var make: String = ""
    var model: String = ""
    var engine: EngineMinimal = EngineMinimal()
    required init() {}
    init(make: String, model: String, engine: EngineMinimal) {
        self.make = make
        self.model = model
        self.engine = engine
    }
}

fileprivate class Engine {
    var horsePower: Int = 0
    var serialNumber: String = ""
    required init() {}
    init(horsePower: Int, serialNumber: String) {
        self.horsePower = horsePower
        self.serialNumber = serialNumber
    }
}

fileprivate class EngineMinimal {
    var horsePower: Int = 0
    required init(){}
    init(horsePower: Int) {
        self.horsePower = horsePower
    }
}


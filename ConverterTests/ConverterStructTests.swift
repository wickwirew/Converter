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


class ConverterStructTests: XCTestCase {
    
    func testConversion() {
        try! Conversion.create(from: Person.self, to: PersonMinimal.self)
        let wes = Person(id: 3, firstName: "Wes", lastName: "Wickwire", age: 25)
        let mini: PersonMinimal = try! Converter.convert(wes)
        
        XCTAssert(mini.firstName == "Wes")
        XCTAssert(mini.lastName == "Wickwire")
    }
    
    func testConversion_DesintationUntyped() {
        try! Conversion.create(from: Person.self, to: PersonMinimal.self)
        let wes = Person(id: 3, firstName: "Wes", lastName: "Wickwire", age: 25)
        let mini = try! Converter.convert(wes, to: PersonMinimal.self)
        
        XCTAssert((mini as! PersonMinimal).firstName == "Wes")
        XCTAssert((mini as! PersonMinimal).lastName == "Wickwire")
    }
    
    func testConversion_SourceUntyped() {
        try! Conversion.create(from: Person.self, to: PersonMinimal.self)
        let wes: Any = Person(id: 3, firstName: "Wes", lastName: "Wickwire", age: 25)
        let mini: PersonMinimal = try! Converter.convert(wes)
        
        XCTAssert(mini.firstName == "Wes")
        XCTAssert(mini.lastName == "Wickwire")
    }
    
    func testConversion_Untyped() {
        try! Conversion.create(from: Person.self, to: PersonMinimal.self)
        let wes: Any = Person(id: 3, firstName: "Wes", lastName: "Wickwire", age: 25)
        let mini = try! Converter.convert(wes, to: PersonMinimal.self)
        
        XCTAssert((mini as! PersonMinimal).firstName == "Wes")
        XCTAssert((mini as! PersonMinimal).lastName == "Wickwire")
    }
    
    func testConversion_Nested() {
        try! Conversion.create(from: Engine.self, to: EngineMinimal.self)
        try! Conversion.create(from: Car.self, to: CarMinimal.self)
        
        let s2k = Car(id: 3, make: "Honda", model: "S2000", engine: Engine(horsePower: 245, serialNumber: "34254352"))
        let mini: CarMinimal = try! Converter.convert(s2k)
        
        XCTAssert(mini.make == "Honda")
        XCTAssert(mini.model == "S2000")
        XCTAssert(mini.engine.horsePower == 245)
    }
    
    func testConversion_Nested_DestinationUntyped() {
        try! Conversion.create(from: Engine.self, to: EngineMinimal.self)
        try! Conversion.create(from: Car.self, to: CarMinimal.self)
        
        let s2k = Car(id: 3, make: "Honda", model: "S2000", engine: Engine(horsePower: 245, serialNumber: "34254352"))
        let mini = try! Converter.convert(s2k, to: CarMinimal.self)
        
        XCTAssert((mini as! CarMinimal).make == "Honda")
        XCTAssert((mini as! CarMinimal).model == "S2000")
        XCTAssert((mini as! CarMinimal).engine.horsePower == 245)
    }
    
    func testConversion_Nested_SourceUntyped() {
        try! Conversion.create(from: Engine.self, to: EngineMinimal.self)
        try! Conversion.create(from: Car.self, to: CarMinimal.self)
        
        let s2k: Any = Car(id: 3, make: "Honda", model: "S2000", engine: Engine(horsePower: 245, serialNumber: "34254352"))
        let mini: CarMinimal = try! Converter.convert(s2k)
        
        XCTAssert(mini.make == "Honda")
        XCTAssert(mini.model == "S2000")
        XCTAssert(mini.engine.horsePower == 245)
    }
    
    func testConversion_Nested_Untyped() {
        try! Conversion.create(from: Engine.self, to: EngineMinimal.self)
        try! Conversion.create(from: Car.self, to: CarMinimal.self)
        
        let s2k = Car(id: 3, make: "Honda", model: "S2000", engine: Engine(horsePower: 245, serialNumber: "34254352"))
        let mini = try! Converter.convert(s2k, to: CarMinimal.self)
        
        XCTAssert((mini as! CarMinimal).make == "Honda")
        XCTAssert((mini as! CarMinimal).model == "S2000")
        XCTAssert((mini as! CarMinimal).engine.horsePower == 245)
    }
    
    func testConversionCustomMapping() {
        try! Conversion.create(from: Person.self, to: Teacher.self)
            .for(property: "name", do: {s,d in d.name = "\(s.firstName) \(s.lastName)"})
        
        let person = Person(id: 7, firstName: "Wes", lastName: "Wickwire", age: 25)
        
        let teacher: Teacher = try! Converter.convert(person)
        
        XCTAssert(teacher.name == "Wes Wickwire")
        XCTAssert(teacher.age == 25)
    }
    
    func testIgnore() {
        try! Conversion.create(from: Person.self, to: PersonMinimal.self)
            .ignore(property: "lastName")
        
        let source = Person(id: 8, firstName: "Wes", lastName: "Wickwire", age: 25)
        let mini: PersonMinimal = try! Converter.convert(source)
        
        XCTAssert(mini.firstName == "Wes")
        XCTAssert(mini.lastName == "")
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

fileprivate struct Teacher {
    var name: String
    var age: Int
}

fileprivate struct Car {
    var id: Int
    var make: String
    var model: String
    var engine: Engine
}

fileprivate struct CarMinimal {
    var make: String
    var model: String
    var engine: EngineMinimal
}

fileprivate struct Engine {
    var horsePower: Int
    var serialNumber: String
}

fileprivate struct EngineMinimal {
    var horsePower: Int = 0
}

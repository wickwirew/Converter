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

import Foundation
import Runtime


public func convert<T>(_ object: Any) throws -> T {
    guard let result = try convert(object, to: T.self) as? T else {
        throw ConverterErrors.couldNotCastValue
    }
    
    return result
}

public func convert(_ object: Any, to destinationType: Any.Type) throws -> Any {    
    if object is ArrayType {
        return try convertArray(object, to: destinationType)
    } else {
        return try convertObject(object, to: destinationType)
    }
}

func convertObject(_ object: Any, to destinationType: Any.Type) throws -> Any {
    
    guard let conversion = conversions["\(type(of: object))\(destinationType)"]
        else { throw ConverterErrors.conversionNotFound }
    
    var result = try createInstance(of: destinationType)
    
    var object = object
    
    for value in conversion.conversions {
        let c = value.value
        try c.run(source: &object, destination: &result)
    }
    
    return result
}

func convertArray(_ object: Any, to destinationType: Any.Type) throws -> Any {
    
    guard let source = object as? [Any] else { throw ConverterErrors.valueNotArray }
    
    guard let destinationElementType = try typeInfo(of: destinationType).genericTypes.first
        else { throw ConverterErrors.arrayTypeUnknown }
    
    guard var result = try createInstance(of: destinationType) as? ArrayType
        else { throw ConverterErrors.arrayTypeUnknown }
    
    for item in source {
        let converted = try convert(item, to: destinationElementType)
        try result.castAndAdd(item: converted)
    }
    
    return result
}

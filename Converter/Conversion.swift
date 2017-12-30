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


var conversions = [String : ModelConversionProtocol]()

/**
 Creates a conversion from the Source model to the Destination model
 */
@discardableResult
public func createConversion<S, D>(from source: S.Type, to destination: D.Type, naming: NameMatching = .loose) throws -> ModelConversion<S, D> {
    
    let sourceProperties = try typeInfo(of: source).properties
    let destinationProperties = try typeInfo(of: destination).properties
    
    var propertyConversions = [String : PropertyConversion]()
    
    for sourceProperty in sourceProperties {
        if let destinationProperty = getPropertyFor(name: sourceProperty.name, properties: destinationProperties, naming: naming) {
            propertyConversions[sourceProperty.name] = propertyConversion(source: sourceProperty, destination: destinationProperty)
        }
    }
    
    let conversion = ModelConversion<S, D>(conversions: propertyConversions)
    conversions[conversion.getKey()] = conversion
    return conversion
}

func propertyConversion(source sourceProperty: PropertyInfo, destination destinationProperty: PropertyInfo) -> PropertyConversion {
    let typesEqual = isType(sourceProperty.type, equalTo: destinationProperty.type)
    return PropertyConversion { source, destination in
        if typesEqual {
            let value = try sourceProperty.get(from: source)
            try destinationProperty.set(value: value, on: &destination)
        } else {
            let value = try sourceProperty.get(from: source)
            let converted = try Converter.convert(value, to: destinationProperty.type)
            try destinationProperty.set(value: converted, on: &destination)
        }
    }
}

func getPropertyFor(name: String, properties: [PropertyInfo], naming: NameMatching) -> PropertyInfo? {
    switch naming {
    case .loose:
        if let property = properties.first(where: {$0.name == name}) {
            return property
        } else if let property = properties.first(where: {$0.name == "_\(name)"}) {
            return property
        } else {
            return nil
        }
    case .strict:
        return properties.first{$0.name == name}
    }
}

func conversionExists(from source: Any.Type, to destination: Any.Type) -> Bool {
    let key = "\(source)\(destination)"
    return conversions[key] != nil
}


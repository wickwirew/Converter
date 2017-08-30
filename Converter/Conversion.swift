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


public final class Conversion {
    
    internal static var conversions = [String : ModelConversionProtocol]()
    
    /**
     Creates a conversion from the Source model to the Destination model
     */
    @discardableResult
    public static func create<TSource, TDestination>(from source: TSource.Type, to destination: TDestination.Type) throws -> ModelConversion<TSource, TDestination> {
        
        let sourceProperties = try Reflection.getProperties(of: source)
        let destinationProperties = try Reflection.getProperties(of: destination)
        
        var conversions = [String : PropertyConversion]()
        
        for sourceProperty in sourceProperties {
            if let destinationProperty = getPropertyFor(name: sourceProperty.name, properties: destinationProperties) {
                
                let typesEqual = sourceProperty.type == destinationProperty.type
                
                let conversion = PropertyConversion() { source, destination in
                    
                    if typesEqual {
                        let value = try sourceProperty.get(from: source)
                        try destinationProperty.set(value: value, on: &destination)
                    } else {
                        let value = try sourceProperty.get(from: source)
                        let converted = try! Converter.convert(value, to: destinationProperty.type)
                        try destinationProperty.set(value: converted, on: &destination)
                    }
                }
                
                conversions[sourceProperty.name] = conversion
            }
        }
        
        let conversion = ModelConversion<TSource, TDestination>(conversions: conversions)
        
        Conversion.conversions[conversion.getKey()] = conversion
        
        return conversion
    }
    
    /**
     Gets the property for the name.
     */
    internal static func getPropertyFor(name: String, properties: [PropertyInfo]) -> PropertyInfo? {
        return properties.first{$0.name == name}
    }
    
}


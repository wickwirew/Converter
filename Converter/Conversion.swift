//
//  Conversion.swift
//  Converter
//
//  Created by Wes on 8/24/17.
//  Copyright © 2017 weswickwire. All rights reserved.
//

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
                        let value = try sourceProperty.get(from: &source)
                        try destinationProperty.set(value: value, on: &destination)
                    } else {
                        let value = try sourceProperty.get(from: &source)
                        guard let converted = try! Converter.convert(value, to: destinationProperty.type) else { return }
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


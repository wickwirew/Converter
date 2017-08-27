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
    
    internal static var conversions = [String : ModelConversion]()
    
    /**
     Creates a conversion from the Source model to the Destination model
     */
    public static func create(from source: Any.Type, to destination: Any.Type) throws {
        
        let sourceProperties = try Reflection.getProperties(of: source)
        let destinationProperties = try Reflection.getProperties(of: destination)
        
        var conversions = [String : PropertyConversion]()
        
        for sourceProperty in sourceProperties {
            if let destinationProperty = getPropertyFor(name: sourceProperty.name, properties: destinationProperties) {
                
                let typesEqual = sourceProperty.type == destinationProperty.type
                
                let conversion = PropertyConversion(sourceProperty: sourceProperty, destinationProperty: destinationProperty) { sourceProperty, destinationProperty, source, destination in
                    
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
        
        let conversion = ModelConversion(conversions: conversions, sourceType: source, destinationType: destination)
        
        Conversion.conversions[conversion.getKey()] = conversion
    }
    
    /**
     Gets the property for the name.
     */
    internal static func getPropertyFor(name: String, properties: [PropertyInfo]) -> PropertyInfo? {
        return properties.first{$0.name == name}
    }
    
}


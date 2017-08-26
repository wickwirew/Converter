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
        
        guard let sourceProperties = Reflection.getProperties(of: source) else { throw ConverterErrors.errorReadingProperties }
        guard let destinationProperties = Reflection.getProperties(of: destination) else { throw ConverterErrors.errorReadingProperties }
        
        var conversions = [String : PropertyConversion]()
        
        for sourceProperty in sourceProperties {
            if let destinationProperty = getPropertyFor(name: sourceProperty.name, properties: destinationProperties) {
                
                let typesEqual = sourceProperty.type == destinationProperty.type
                
                let conversion = PropertyConversion(sourceProperty: sourceProperty, destinationProperty: destinationProperty) { sourceProperty, destinationProperty, source, destination in
                    
                    if typesEqual {
                        guard let value = sourceProperty.get(from: &source) else { return }
                        destinationProperty.set(value: value, on: &destination)
                    } else {
                        guard let value = sourceProperty.get(from: &source) else { return }
                        guard let converted = try! Converter.convert(value, to: destinationProperty.type) else { return }
                        destinationProperty.set(value: converted, on: &destination)
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


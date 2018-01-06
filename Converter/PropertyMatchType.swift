//
//  PropertyMatch.swift
//  Converter
//
//  Created by Wes Wickwire on 1/3/18.
//  Copyright © 2018 weswickwire. All rights reserved.
//

import Foundation
import Runtime


protocol PropertyMatchType {
    var propertyName: String { get }
    func createConversion() -> PropertyConversionProtocol
}

extension PropertyMatchType {
    
    func directConversion(from sourceProperty: PropertyInfo, to destinationProperty: PropertyInfo) -> (inout Any, inout Any) throws -> Void {
        return { source, destination in
            let value = try sourceProperty.get(from: source)
            try destinationProperty.set(value: value, on: &destination)
        }
    }
    
}


struct PropertyMatch: PropertyMatchType {
    
    let sourceProperty: PropertyInfo
    let destinationProperty: PropertyInfo
    
    init(source: PropertyInfo, destination: PropertyInfo) {
        sourceProperty = source
        destinationProperty = destination
    }
    
    var propertyName: String {
        return sourceProperty.name
    }
    
    func createConversion() -> PropertyConversionProtocol {
        let sourceProperty = self.sourceProperty
        let destinationProperty = self.destinationProperty
        let typesEqual = isType(sourceProperty.type, equalTo: destinationProperty.type)
        
        if typesEqual {
            return PropertyConversion(conversion: directConversion(from: sourceProperty, to: destinationProperty))
        } else {
            return PropertyConversion { source, destination in
                let value = try sourceProperty.get(from: source)
                let converted = try convert(value, to: destinationProperty.type)
                try destinationProperty.set(value: converted, on: &destination)
            }
        }
    }
}


struct NestedPropertyMatch: PropertyMatchType {
    
    var owner: PropertyInfo
    var sourceProperty: PropertyInfo
    var nestedProperty: PropertyInfo
    
    var propertyName: String {
        return sourceProperty.name
    }
    
    func createConversion() -> PropertyConversionProtocol {
        
        let owner = self.owner
        let sourceProperty = self.sourceProperty
        let nestedProperty = self.nestedProperty
        
        return PropertyConversion { source, destination in
            let o = try owner.get(from: source)
            let value = try nestedProperty.get(from: o)
            try sourceProperty.set(value: value, on: &destination)
        }
    }
}

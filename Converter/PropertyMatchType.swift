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
        return PropertyConversion { source, destination in
            if typesEqual {
                let value = try sourceProperty.get(from: source)
                try destinationProperty.set(value: value, on: &destination)
            } else {
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
    var destinationProperty: PropertyInfo
    
    var propertyName: String {
        return sourceProperty.name
    }
    
    func createConversion() -> PropertyConversionProtocol {
        fatalError()
    }
}

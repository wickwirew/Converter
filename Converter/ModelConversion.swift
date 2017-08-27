//
//  ModelConversion.swift
//  Converter
//
//  Created by Wes on 8/25/17.
//  Copyright © 2017 weswickwire. All rights reserved.
//

import Foundation

public protocol ModelConversionProtocol {
    var conversions: [String : PropertyConversionProtocol] { get set }
}

public class ModelConversion<TSource, TDestination>: ModelConversionProtocol {
    
    /**
     All of the property conversions required for the model.
     The key is the property name.
     */
    public var conversions: [String : PropertyConversionProtocol]
    
    
    public init(conversions: [String : PropertyConversion]) {
        self.conversions = conversions
    }
    
    public func `for`(property: String, do conversion: @escaping (inout TSource, inout TDestination) -> Void) {
        conversions[property] = CustomPropertyConversion(conversion: conversion)
    }
    
    /**
     Gets the key for the conversion dictionary
     */
    func getKey() -> String {
        return String(describing: TSource.self) + String(describing: TDestination.self)
    }
}

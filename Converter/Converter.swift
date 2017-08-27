//
//  Convert.swift
//  Converter
//
//  Created by Wes on 8/24/17.
//  Copyright © 2017 weswickwire. All rights reserved.
//

import Foundation
import Runtime


public final class Converter {
    
    public static func convert<T>(_ object: Any) throws -> T {
        guard let result = try convert(object, to: T.self) as? T else {
            throw ConverterErrors.couldNotCastValue
        }
        
        return result
    }
    
    public static func convert(_ object: Any, to destinationType: Any.Type) throws -> Any? {
        
        guard let conversion = Conversion.conversions[String(describing: type(of: object)) + String(describing: destinationType)]
            else { throw ConverterErrors.conversionNotFound }
        
        var result = try Construct.build(type: destinationType)
        
        var object = object
        
        for value in conversion.conversions {
            let c = value.value
            try c.runConversion(source: &object, destination: &result)
        }
        
        return result
    }
    
}

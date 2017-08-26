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
    
    public static func convert(_ object: Any, to destinationType: Any.Type) throws -> Any? {
        
        guard let conversion = Conversion.conversions[String(describing: type(of: object)) + String(describing: destinationType)]
            else { throw ConverterErrors.conversionNotFound }
        
        guard var result = Construct.build(type: destinationType) else { return nil }
        
        var object = object
        
        for value in conversion.conversions {
            let c = value.value
            c.conversion(c.sourceProperty, c.destinationProperty, &object, &result)
        }
        
        return result
    }
    
}

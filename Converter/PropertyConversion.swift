//
//  PropertyConversion.swift
//  Converter
//
//  Created by Wes on 8/24/17.
//  Copyright © 2017 weswickwire. All rights reserved.
//

import Foundation
import Runtime



struct PropertyConversion {

    /**
     The property in the source type
     */
    let sourceProperty: PropertyInfo
    
    /**
     The property in the destination type
     */
    let destinationProperty: PropertyInfo
    
    /**
     The closure that is responsible for setting the value on the destination
     - Parameters: sourceProperty, destinationProperty, source, destination
     */
    let conversion: (PropertyInfo, PropertyInfo, inout Any, inout Any) -> Void
    
}

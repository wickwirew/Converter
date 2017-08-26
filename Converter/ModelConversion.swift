//
//  ModelConversion.swift
//  Converter
//
//  Created by Wes on 8/25/17.
//  Copyright © 2017 weswickwire. All rights reserved.
//

import Foundation



struct ModelConversion {
    
    /**
     All of the property conversions required for the model.
     The key is the property name.
     */
    let conversions: [String : PropertyConversion]
    
    /**
     Source model type
     */
    let sourceType: Any.Type
    
    /**
     Desintation model type
     */
    let destinationType: Any.Type
    
    /**
     Gets the key for the conversion dictionary
     */
    func getKey() -> String {
        return String(describing: sourceType) + String(describing: destinationType)
    }
}

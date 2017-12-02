//
//  TypeComparer.swift
//  Converter
//
//  Created by Wes Wickwire on 11/6/17.
//  Copyright © 2017 weswickwire. All rights reserved.
//

import Foundation


func isType(_ type1: Any.Type, equalTo type2: Any.Type) -> Bool {
    
    if type1 == type2 {
        return true
    }
    
    if let type1 = type1 as? OptionalType.Type {
        return type1.wrappedType == type2
    } else if let type2 = type2 as? OptionalType.Type {
        return type2.wrappedType == type1
    }
    
    return false
}

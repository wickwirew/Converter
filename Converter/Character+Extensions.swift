//
//  File.swift
//  Converter
//
//  Created by Wes Wickwire on 12/30/17.
//  Copyright © 2017 weswickwire. All rights reserved.
//

import Foundation



extension Character {
    
    var isUppercase: Bool {
        return "A"..."Z" ~= self
    }
    
    // TODO find a better solution
    func lowercased() -> Character {
        if !self.isUppercase {
            return self
        }
        
        return String(describing: self).lowercased().first ?? self
    }
    
    // TODO find a better solution
    func uppercased() -> Character {
        if !self.isUppercase {
            return self
        }
        
        return String(describing: self).uppercased().first ?? self
    }
}

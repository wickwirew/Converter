//
//  String+Extensions.swift
//  Converter
//
//  Created by Wes Wickwire on 12/30/17.
//  Copyright © 2017 weswickwire. All rights reserved.
//

import Foundation



extension String {
    
    func capitalizedFirst() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
}

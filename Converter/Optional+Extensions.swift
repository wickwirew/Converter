//
//  Optional+Extensions.swift
//  Converter
//
//  Created by Wes Wickwire on 11/6/17.
//  Copyright © 2017 weswickwire. All rights reserved.
//

import Foundation


protocol OptionalType {
    static var wrappedType: Any.Type { get }
}

extension Optional: OptionalType {
    static var wrappedType: Any.Type {
        return Wrapped.self
    }
}

//
// Created by Wes on 8/31/17.
// Copyright (c) 2017 weswickwire. All rights reserved.
//

import Foundation


/**
Protocol to mark the arrays.
Also add helper functions.
*/
protocol ArrayType {
    mutating func castAndAdd(item: Any) throws
}

extension Array: ArrayType {

    /**
    When working with arrays we will usually have a correctly typed array
    but cant add an Any typed object to it. This will cast the value and add it.
    */
    mutating func castAndAdd(item: Any) throws {
        if let value = item as? Element {
            self.append(value)
        } else {
            throw ConverterErrors.couldNotCastValue
        }
    }
}
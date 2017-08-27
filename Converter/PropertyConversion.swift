//
//  PropertyConversion.swift
//  Converter
//
//  Created by Wes on 8/24/17.
//  Copyright © 2017 weswickwire. All rights reserved.
//

import Foundation
import Runtime


public protocol PropertyConversionProtocol {
    func runConversion(source: inout Any, destination: inout Any) throws
}

public struct PropertyConversion: PropertyConversionProtocol {

    /**
     The closure that is responsible for setting the value on the destination
     - Parameters: source, destination
     */
    let conversion: (inout Any, inout Any) throws -> Void
    
    public func runConversion(source: inout Any, destination: inout Any) throws {
        try conversion(&source, &destination)
    }
}



public struct CustomPropertyConversion<TSource, TDestination>: PropertyConversionProtocol {
    
    let conversion: (inout TSource, inout TDestination) throws -> Void
    
    public func runConversion(source: inout Any, destination: inout Any) throws {
        guard var sourceTyped = source as? TSource else { return }
        guard var destinationTyped = destination as? TDestination else { return }
        try conversion(&sourceTyped, &destinationTyped)
        destination = destinationTyped
    }
}

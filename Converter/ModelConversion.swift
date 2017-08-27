// MIT License
//
// Copyright (c) 2017 Wesley Wickwire
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation

public protocol ModelConversionProtocol {
    var conversions: [String : PropertyConversionProtocol] { get set }
}

public class ModelConversion<TSource, TDestination>: ModelConversionProtocol {
    
    /**
     All of the property conversions required for the model.
     The key is the property name.
     */
    public var conversions: [String : PropertyConversionProtocol]
    
    
    public init(conversions: [String : PropertyConversion]) {
        self.conversions = conversions
    }
    
    @discardableResult
    public func `for`(property: String, do conversion: @escaping (inout TSource, inout TDestination) -> Void) -> ModelConversion<TSource, TDestination>{
        conversions[property] = CustomPropertyConversion(conversion: conversion)
        return self
    }
    
    /**
     Gets the key for the conversion dictionary
     */
    func getKey() -> String {
        return String(describing: TSource.self) + String(describing: TDestination.self)
    }
}

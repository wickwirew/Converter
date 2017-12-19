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
import Runtime



public protocol PropertyConversionProtocol {
    func runConversion(source: inout Any, destination: inout Any) throws
}


public struct PropertyConversion: PropertyConversionProtocol {
    
    let conversion: (inout Any, inout Any) throws -> Void
    
    public func runConversion(source: inout Any, destination: inout Any) throws {
        try conversion(&source, &destination)
    }
}

public struct CustomPropertyConversion<S, D, T>: PropertyConversionProtocol {
    
    let property: String
    let getter: (S) throws -> T
    
    public func runConversion(source: inout Any, destination: inout Any) throws {
        guard let source = source as? S else { return }
        let value = try getter(source)
        let info = try typeInfo(of: D.self)
        try info.property(named: property).set(value: value, on: &destination)
    }
}

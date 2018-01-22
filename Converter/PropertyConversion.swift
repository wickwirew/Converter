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
    func run(source: inout Any, destination: inout Any) throws
}


public struct PropertyConversion: PropertyConversionProtocol {
    
    let conversion: (inout Any, inout Any) throws -> Void
    
    public func run(source: inout Any, destination: inout Any) throws {
        try conversion(&source, &destination)
    }
}


public protocol CustomPropertyConversion: PropertyConversionProtocol {
    associatedtype Source
    associatedtype Value
    associatedtype Destination
    var property: String { get set }
    func getValue(from source: Source) throws -> Value
}

extension CustomPropertyConversion {
    
    public func run(source: inout Any, destination: inout Any) throws {
        guard let source = source as? Source else { return }
        let value = try getValue(from: source)
        let info = try typeInfo(of: Destination.self)
        try info.property(named: property).set(value: value, on: &destination)
    }
}

public struct CustomPropertyConversionClosure<S, D, V>: CustomPropertyConversion {
    
    public typealias Source = S
    public typealias Value = V
    public typealias Destination = D
    
    public var property: String
    public let getter: (Source) throws -> Value
    
    public func getValue(from source: Source) throws -> Value {
        return try getter(source)
    }
}

public struct CustomPropertyConversionKeyPath<S, D, V>: CustomPropertyConversion {
    
    public typealias Source = S
    public typealias Value = V
    public typealias Destination = D
    
    public var property: String
    public let path: KeyPath<S, V>
    
    public func getValue(from source: Source) throws -> Value {
        return source[keyPath: path]
    }
}

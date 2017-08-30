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


public final class Converter {
    
    public static func convert<T>(_ object: Any) throws -> T {
        guard let result = try convert(object, to: T.self) as? T else {
            throw ConverterErrors.couldNotCastValue
        }
        
        return result
    }
    
    public static func convert(_ object: Any, to destinationType: Any.Type) throws -> Any {
        
        guard let conversion = Conversion.conversions[String(describing: type(of: object)) + String(describing: destinationType)]
            else { throw ConverterErrors.conversionNotFound }
        
        var result = try Construct.build(type: destinationType)
        
        var object = object
        
        for value in conversion.conversions {
            let c = value.value
            try c.runConversion(source: &object, destination: &result)
        }
        
        return result
    }
    
}

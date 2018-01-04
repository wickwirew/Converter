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


var conversions = [String : ModelConversionProtocol]()

@discardableResult
public func createConversion<S, D>(from source: S.Type, to destination: D.Type, matching: NameMatching = .loose) throws -> ModelConversion<S, D> {
    
    let sourceProperties = try typeInfo(of: source).properties
    let destinationProperties = try typeInfo(of: destination).properties
    
    var propertyConversions = [String : PropertyConversionProtocol]()
    
    let matches = getMatches(sourceProperties, destinationProperties, matching)
    
    for match in matches {
        propertyConversions[match.propertyName] = match.createConversion()
    }
    
    let conversion = ModelConversion<S, D>(conversions: propertyConversions)
    conversions[conversion.getKey()] = conversion
    return conversion
}

func getMatches(_ sourceProperties: [PropertyInfo], _ destinationProperties: [PropertyInfo], _ matching: NameMatching) -> [PropertyMatchType] {
    var matches = [PropertyMatchType]()
    for sourceProperty in sourceProperties {
        if let destinationProperty = getPropertyFor(name: sourceProperty.name, properties: destinationProperties, matching: matching) {
            matches.append(PropertyMatch(source: sourceProperty, destination: destinationProperty))
        }
    }
    return matches
}

func getPropertyFor(name: String, properties: [PropertyInfo], matching: NameMatching) -> PropertyInfo? {
    switch matching {
    case .loose:
        let possibilities = possibleNames(from: name)
        return properties.first{possibilities.contains($0.name)}
    case .strict:
        return properties.first{$0.name == name}
    }
}

func conversionExists(from source: Any.Type, to destination: Any.Type) -> Bool {
    let key = "\(source)\(destination)"
    return conversions[key] != nil
}


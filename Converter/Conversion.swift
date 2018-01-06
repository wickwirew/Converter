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
    for destinationProperty in destinationProperties {
        if let match = getMatch(for: destinationProperty, matching: matching, sourceProperties: sourceProperties) {
            matches.append(match)
        }
    }
    return matches
}


func getMatch(for destination: PropertyInfo, matching: NameMatching, sourceProperties: [PropertyInfo]) -> PropertyMatchType? {
    switch matching {
    case .loose:
        
        let naming = NamingContext(from: destination.name)
        
        if let property = sourceProperties.first(where: {naming.possibilities.contains($0.name)}) {
            return PropertyMatch(source: property, destination: destination)
        } else {
            
            let nestedPossibilies = naming.nestedPossibilities
            
            for (sourceName, nestedPropertyName) in nestedPossibilies {
                
                guard let sourceProperty = sourceProperties.first(where: { $0.name == sourceName }),
                    let info = try? typeInfo(of: sourceProperty.type),
                    let nestedProperty = try? info.property(named: nestedPropertyName)
                    else { continue }
                
                return NestedPropertyMatch(owner: sourceProperty, sourceProperty: destination, nestedProperty: nestedProperty)
            }
            
            return nil
        }
    case .strict:
        guard let property = sourceProperties.first(where: {$0.name == destination.name})
            else { return nil }
        return PropertyMatch(source: property, destination: destination)
    }
}

func conversionExists(from source: Any.Type, to destination: Any.Type) -> Bool {
    let key = "\(source)\(destination)"
    return conversions[key] != nil
}


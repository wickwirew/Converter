//
//  NameMatching.swift
//  Converter
//
//  Created by Wes Wickwire on 12/30/17.
//  Copyright © 2017 weswickwire. All rights reserved.
//

import Foundation


public enum NameMatching {
    case loose
    case strict
}


func possibleNames(from value: String) -> [String] {
    let w = words(from: value)
    return [
        value,
        "_\(value)",
        toCamelCasing(words: w),
        toPascalCasing(words: w),
        toSnakeCasing(words: w)
    ]
}

func words(from value: String) -> [String] {
    var word = ""
    var words = [String]()
    
    for char in value {
        if char == "_" {
            if word != "" {
                words.append(word)
                word = ""
            }
        } else if char.isUppercase {
            if word != "" {
                words.append(word)
                word = ""
            }
            word = "\(char)".lowercased()
        } else {
            word += "\(char)"
        }
    }
    
    words.append(word)
    
    return words
}

func toSnakeCasing(words: [String]) -> String {
    return words.joined(separator: "_")
}

func toPascalCasing(words: [String]) -> String {
    return words
        .map{ $0.capitalizedFirst() }
        .joined()
}

func toCamelCasing(words: [String]) -> String {
    return (0..<words.count)
        .map{ $0 == 0 ? words[$0] : words[$0].capitalizedFirst() }
        .joined()
}

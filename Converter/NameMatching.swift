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
    return [
        withBeginningUnderscrore(value: value),
        toPascalCasing(value: value),
        toSnakeCasing(value: value),
        value.lowercased(),
        value.uppercased()
    ]
}

func withBeginningUnderscrore(value: String) -> String {
    return "_\(value)"
}

func toSnakeCasing(value: String) -> String {
    let uppers = CharacterSet.uppercaseLetters
    
    var result = ""
    for char in value.unicodeScalars {
        if uppers.contains(char) {
            let lower = "\(char)".lowercased()
            result += "_\(lower)"
        } else {
            result += "\(char)"
        }
    }
    return result
}

func toPascalCasing(value: String) -> String {
    if let first = value.unicodeScalars.first, CharacterSet.lowercaseLetters.contains(first) {
        let cap = "\(first)".capitalized
        return "\(cap)\(value[value.index(value.startIndex, offsetBy: 1)..<value.endIndex])"
    } else {
        return value
    }
}

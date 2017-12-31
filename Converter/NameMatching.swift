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

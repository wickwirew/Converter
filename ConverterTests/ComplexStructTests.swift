//
//  ComplexTests.swift
//  Converter
//
//  Created by Wes on 8/31/17.
//  Copyright © 2017 weswickwire. All rights reserved.
//

import XCTest
import Runtime
@testable import Converter


class ComplexStructTests: XCTestCase {
    
    func test() {
        try! Conversion.create(from: Post.self, to: PostMinimal.self)
        try! Conversion.create(from: Author.self, to: AuthorMinimal.self)
        
        let post = Post()
        
        let mini: PostMinimal = try! Converter.convert(post)
        
        XCTAssert(mini.id == 7)
        XCTAssert(mini.title == "title")
        XCTAssert(mini.author.email == "email@email.com")
    }
    
}



fileprivate struct Post {
    var id = 7
    var authorId = 5
    var author = Author()
    var title = "title"
    var body = "body"
}


fileprivate struct Author {
    var id = 0
    var username = "username"
    var firstName = "firstName"
    var lastName = "lastName"
    var email = "email@email.com"
}

fileprivate struct Comment {
    var authorId = 5
    var body = "body"
}


fileprivate struct PostMinimal {
    var id = 0
    var author = AuthorMinimal()
    var title = ""
}


fileprivate struct AuthorMinimal {
    var id = 0
    var email = ""
}
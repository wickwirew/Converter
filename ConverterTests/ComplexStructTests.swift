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

import XCTest
import Runtime
@testable import Converter


class ComplexStructTests: XCTestCase {
    
    func test() {
        try! createConversion(from: Post.self, to: PostMinimal.self)
        try! createConversion(from: Author.self, to: AuthorMinimal.self)
        try! createConversion(from: Comment.self, to: CommentMinimal.self)
        
        let post = Post()
        
        let mini: PostMinimal = try! Converter.convert(post)
        
        XCTAssert(mini.id == 7)
        XCTAssert(mini.title == "title")
        XCTAssert(mini.author.email == "email@email.com")
        XCTAssert(mini.comments.count == 2)
        XCTAssert(mini.comments[0].title == "title")
        XCTAssert(mini.comments[1].title == "title")
        XCTAssert(mini.nestedName == "hey there")
    }
    
    func testArray() throws {
        try! createConversion(from: Author.self, to: AuthorMinimal.self)
        let authors = [Author(), Author(), Author(), Author(), Author(), Author()]
        let min: [AuthorMinimal] = try Converter.convert(authors)
        for i in 0..<authors.count {
            XCTAssert(authors[i].id == min[i].id)
            XCTAssert(authors[i].email == min[i].email)
        }
    }
    
}



fileprivate struct Post {
    var id = 7
    var authorId = 5
    var author = Author()
    var title = "title"
    var body = "body"
    var something: String? = nil
    var comments = [Comment(), Comment()]
    var nested = Nested(name: "hey there")
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
    var title = "title"
    var body = "body"
}

fileprivate struct CommentMinimal {
    var title = "title"
}


fileprivate struct PostMinimal {
    var id = 0
    var author = AuthorMinimal()
    var title = ""
    var comments = [CommentMinimal]()
    var something = ""
    var nestedName = ""
}


fileprivate struct AuthorMinimal {
    var id = 0
    var email = ""
}

fileprivate struct Nested {
    var name: String
}

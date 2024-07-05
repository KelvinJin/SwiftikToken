import XCTest
@testable import SwiftikToken

final class SwiftikTokenTests: XCTestCase {
    func testExample() async throws {
        let tokenizer = Tiktoken(encoding: .cl100k)
        let tokens = try await tokenizer.encode(text: "hello world")
        XCTAssertEqual([15339, 1917], tokens)
    }
    
    func testChinese() async throws {
        let tokenizer = Tiktoken(encoding: .cl100k)
        let tokens = try await tokenizer.encode(text: "这都是什么玩意啊")
        XCTAssertEqual([44388, 72368, 21043, 6271, 222, 82696, 29207, 102, 37689, 28308, 232], tokens)
    }
}

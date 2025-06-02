//
//  exampleTests.swift
//  exampleTests
//
//  Created by ab180 on 4/1/25.
//

import Testing
@testable import example

struct exampleTests {

    @Test func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
        #expect(true, "기본 테스트 통과")
    }

}

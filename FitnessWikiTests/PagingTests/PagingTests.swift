//
//  PagingTests.swift
//  Tests
//
//  Created by Andrei Mirzac on 28/02/2021.
//

import XCTest
import ReSwift
@testable import FitnessWiki

class PagingTests: XCTestCase {

    func testInitialPagingState() {
        let pageData = PageData(count: 3, next: "https://example/test", previous: "https://example/test")
        let paging = Paging(values: ["value"], data: pageData)
        XCTAssertNil(paging.state)
    }

    func testCompletedPagingState() {
        let pageData = PageData(count: 3, next: nil, previous: "https://example/test")
        let paging = Paging(values: ["value"], data: pageData)
        XCTAssertNotNil(paging.state)
        XCTAssertEqual(paging.state, .completed)
    }
}

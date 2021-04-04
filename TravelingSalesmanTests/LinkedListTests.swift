//
//  LinkedListTests.swift
//  TravelingSalesmanTests
//
//  Created by Nail Sharipov on 12.03.2021.
//

import XCTest
@testable import TravelingSalesman

final class LinkedListTests: XCTestCase {

    func test_00() throws {
        let array = [0, 1, 2, 3]
        let list = ClosedLinkedList(array: array)
        
        XCTAssertEqual(array, list.array)
    }
    
    func test_01() throws {
        let array = [0, 1, 2, 3, 4, 5]
        var list = ClosedLinkedList(array: array)
        
        list.turnOver(start: list[3], end: list[5])
        
        XCTAssertEqual([0, 1, 2, 5, 4, 3], list.array)
    }
    
}

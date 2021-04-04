//
//  CompareTests.swift
//  TravelingSalesmanTests
//
//  Created by Nail Sharipov on 18.03.2021.
//

import XCTest
import CoreGraphics
@testable import TravelingSalesman

final class CompareTests: XCTestCase {

    func test_00() throws {
//        let n = 7
//        var points = [CGPoint](repeating: .zero, count: n)
//        
//        let a: Int = 4

//        for _ in 0...100 {
//            for i in 0..<n {
//                points[i] = CGPoint(x: 5 * Int.random(in: -a...a), y: 5 * Int.random(in: -a...a))
//            }
//
//            let matrix = AdMatrix(nodes: points, scale: 1000)
//
//            let solution0 = ReduceSolution.minPath(matrix: matrix)
//            let solution1 = ConditionBruteForceSolution().minPath(matrix: matrix)
//
//            let len0 = matrix.closedLength(path: solution0)
//            let len1 = matrix.closedLength(path: solution1)
//
//            if len0 != len1 {
//                print("len0: \(len0), len1: \(len1)")
//                print("-----")
//                points.printDebug()
//            }
//            XCTAssertEqual(len0, len1)
//        }
//

    }

}


private extension Array where Element == CGPoint {
    
    
    func printDebug() {
        var str = String()
        let n = self.count
        str.append("[")
        for i in 1...n {
            let p = self[i-1]
            str.append("CGPoint(x: \(p.x), y: \(p.y))")
            if i != n {
                str.append(", ")
            }
        }
        str.append("]")
        print(str)
    }
}

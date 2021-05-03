//
//  AdMatrix.swift
//  TravelingSalesmanLibrary
//
//  Created by Nail Sharipov on 15.04.2021.
//

import CoreGraphics

struct UnsafeAdMatrix {
    
    let size: Int
    private let buffer: UnsafeMutablePointer<Int>
    
    @inline(__always)
    subscript(i: Int, j: Int) -> Int {
        buffer[i &* size &+ j]
    }

    init(matrix: AdMatrix) {
        size = matrix.size
        buffer = UnsafeMutablePointer<Int>.allocate(capacity: matrix.buffer.count)
        buffer.initialize(from: matrix.buffer, count: matrix.buffer.count)
    }
    
    func dealocate() {
        buffer.deinitialize(count: size * size)
        buffer.deallocate()
    }
    
    @inline(__always)
    func closedLength(path: [Int]) -> Int {
        guard path.count == size else {
            fatalError("path size is wrong")
        }
        var a = path[size - 1]
        var l: Int = 0
        for b in path {
            l += self[a, b]
            a = b
        }
        return l
    }

    @inline(__always)
    func isNotPossibleCase(a: Int, b: Int, c: Int, d: Int) -> Bool {
        let ab = self[a, b]
        let cd = self[c, d]
        
        let ac = self[a, c]
        let bd = self[b, d]

        let bc = self[b, c]
        let da = self[d, a]
        
        let abcd = ab + cd // edge
        let acbd = ac + bd
        let bcda = bc + da

        return abcd > acbd && abcd > bcda
    }
    
    @inline(__always)
    func isPossibleCase(a: Int, b: Int, c: Int, d: Int) -> Bool {
        let ab = self[a, b]
        let cd = self[c, d]

        let ac = self[a, c]
        let bd = self[b, d]

        let bc = self[b, c]
        let da = self[d, a]
        
        let abcd = ab + cd // edge
        let acbd = ac + bd
        let bcda = bc + da
        
        return abcd <= acbd || abcd <= bcda
    }
}

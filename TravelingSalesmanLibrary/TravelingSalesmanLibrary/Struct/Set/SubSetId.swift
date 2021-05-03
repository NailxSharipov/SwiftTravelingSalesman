//
//  SubSetId.swift
//  TravelingSalesmanLibrary
//
//  Created by Nail Sharipov on 27.04.2021.
//

struct SubPath {
    let start: Int
    let end: Int
    let length: Int
}

extension Array where Element == Int {
    
    @inline(__always)
    func subSet(start: Int, end: Int, matrix: UnsafeAdMatrix) -> (UInt64, SubPath) {
        let zero: UInt64 = 1

        var a = self[start]
        let a0 = a
        var mask = (zero << a)
        var len = 0
        
        for i in start + 1...end {
            let b = self[i]
            mask = mask | (zero << b)
            len += matrix[a, b]
            a = b
        }

        return (mask, SubPath(start: a0, end: a, length: len))
    }

}

extension FixArray {
    
    @inline(__always)
    func subSet(start: Int, end: Int, matrix: UnsafeAdMatrix) -> (UInt64, SubPath) {
        let zero: UInt64 = 1

        var a = self[start]
        let a0 = a
        var mask = (zero << a)
        var len = 0
        
        for i in start + 1...end {
            let b = self[i]
            mask = mask | (zero << b)
            len += matrix[a, b]
            a = b
        }

        return (mask, SubPath(start: a0, end: a, length: len))
    }

}

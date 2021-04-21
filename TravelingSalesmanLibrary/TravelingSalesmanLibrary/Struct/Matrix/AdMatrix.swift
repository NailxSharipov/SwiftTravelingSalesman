//
//  AdMatrix.swift
//  TravelingSalesmanLibrary
//
//  Created by Nail Sharipov on 15.04.2021.
//

import CoreGraphics

public struct AdMatrix {
    
    let size: Int
    private let array: [Int]
    
    @inline(__always)
    subscript(i: Int, j: Int) -> Int {
        array[i * size + j]
    }
    
    public init(array: [Int]) {
        self.size = Int(Double(array.count).squareRoot().rounded())
        self.array = array
        assert(size * size == array.count)
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
    
    func isConflict(a: Int, b: Int, c: Int, d: Int) -> Bool {
        let ab = self[a, b]
        let cd = self[c, d]

        let ac = self[a, c]
        let bd = self[b, d]

        let bc = self[b, c]
        let da = self[d, a]
        
        let abcd = ab + cd // edge
        let acbd = ac + bd
        let bcda = bc + da
        
        return abcd > acbd || abcd > bcda
    }

}

public extension AdMatrix {
    
    static let defaultScale: CGFloat = 10000
    
    init(nodes: [CGPoint], scale: CGFloat = Self.defaultScale) {
        self.size = nodes.count
        let count = size * size
        var array = [Int](repeating: 0, count: count)
        for i in 0..<size - 1 {
            for j in (i + 1)..<size {
                let a = nodes[i]
                let b = nodes[j]
                let dx = a.x - b.x
                let dy = a.y - b.y
                let l = Int((dx * dx + dy * dy).squareRoot() * scale)
                
                let k0 = i * size + j
                let k1 = j * size + i
                
                array[k0] = l
                array[k1] = l
            }
        }
        self.array = array
    }
    
    func scale(length: Int, scale: CGFloat = Self.defaultScale) -> CGFloat {
        CGFloat(length) / scale
    }
    
}

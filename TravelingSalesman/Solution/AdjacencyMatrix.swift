//
//  DistanceCache.swift
//  TravelingSalesman
//
//  Created by Nail Sharipov on 07.03.2021.
//

import CoreGraphics

struct AdjacencyMatrix {
    
    let size: Int
    private let array: [CGFloat]
    
    @inline(__always)
    subscript(i: Int, j: Int) -> CGFloat {
        array[i * size + j]
    }
    
    init(array: [CGFloat]) {
        self.size = Int(sqrt(Double(array.count)).rounded())
        self.array = array
        assert(size * size == array.count)
    }
    
    @inline(__always)
    func closedLength(path: [Int]) -> CGFloat {
        guard path.count == size else {
            fatalError("path size is wrong")
        }
        var a = path[size - 1]
        var l: CGFloat = 0
        for b in path {
            l += self[a, b]
            a = b
        }
        return l
    }
    
    func openLength(path: [Int]) -> CGFloat {
        guard path.count >= size else {
            fatalError("path size is wrong")
        }
        var a = path[0]
        var l: CGFloat = 0
        for b in path { // first aa == 0
            l += self[a, b]
            a = b
        }
        return l
    }
    
}

extension AdjacencyMatrix {
    
    init(nodes: [CGPoint]) {
        self.size = nodes.count
        let count = size * size
        var array = [CGFloat](repeating: 0, count: count)
        for i in 0..<size - 1 {
            for j in (i + 1)..<size {
                let a = nodes[i]
                let b = nodes[j]
                let dx = a.x - b.x
                let dy = a.y - b.y
                let l = sqrt(dx * dx + dy * dy)
                
                let k0 = i * size + j
                let k1 = j * size + i
                
                array[k0] = l
                array[k1] = l
            }
        }
        self.array = array
    }
}

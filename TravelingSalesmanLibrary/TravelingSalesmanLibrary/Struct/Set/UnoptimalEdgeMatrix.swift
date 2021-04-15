//
//  UnoptimalEdgeMatrix.swift
//  TravelingSalesmanLibrary
//
//  Created by Nail Sharipov on 15.04.2021.
//

struct UnoptimalEdgeMatrix {

    private let size: Int
    private var array: [Bool]

    @inline(__always)
    subscript(a: Int, b: Int) -> Bool {
        get {
            array[a * size + b]
        }
        set {
            array[a * size + b] = newValue
        }
    }
    
    init(size: Int) {
        self.size = size
        self.array = [Bool](repeating: true, count: size * size)
    }
}

extension UnoptimalEdgeMatrix: CustomStringConvertible {
    
    var description: String {
        var result = String()
        for a in 0..<size {
            var addAnithing = false
            for b in 0..<size {
                if self[a, b] {
                    addAnithing = true
                    result.append("\(a)-\(b) ")
                }
            }
            if addAnithing {
                result.append("\n")
            }
        }
        
        return result
    }
}

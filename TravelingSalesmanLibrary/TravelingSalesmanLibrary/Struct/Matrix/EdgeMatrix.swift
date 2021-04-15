//
//  EdgeMatrix.swift
//  TravelingSalesmanLibrary
//
//  Created by Nail Sharipov on 15.04.2021.
//


struct EdgeMatrix {

    let size: Int
    private let array: [UnoptimalEdgeMatrix]

    @inline(__always)
    subscript(i: Int, j: Int) -> UnoptimalEdgeMatrix {
        array[i * size + j]
    }

    init(matrix: AdMatrix) {
        self.size = matrix.size

        var buffer = Array(repeating: UnoptimalEdgeMatrix(size: size), count: size * size)

        for a in 0..<size {
            for b in 0..<size where a != b {
                let j = a * size + b
                var set = buffer[j]
                for c in 0..<size where c != a && c != b {
                    for d in 0..<size where d != a && d != b && d != c {
                        if matrix.isPossibleCase(a: a, b: b, c: c, d: d) {
                            set[c, d] = false
                        }
                    }
                }

                for x in 0..<size where x != b && x != a {
                    set[b, x] = false
                    set[x, a] = false
                }
                
                buffer[j] = set
//                debugPrint("---------")
//                debugPrint("[\(a)\(b)]")
//                debugPrint(set)
            }
        }

        self.array = buffer
    }
}


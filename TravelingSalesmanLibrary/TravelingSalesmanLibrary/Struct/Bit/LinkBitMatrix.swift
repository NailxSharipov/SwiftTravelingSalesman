//
//  LinkBitMatrix.swift
//  TravelingSalesmanLibrary
//
//  Created by Nail Sharipov on 20.04.2021.
//

struct LinkBitMatrix {

    let size: Int
    let base: BitMatrix
    private let array: [BitMatrix?]

    @inline(__always)
    subscript(i: Int, j: Int) -> BitMatrix? {
        array[index(i, j)]
    }
    
    @inline(__always)
    func index(_ i: Int, _ j: Int) -> Int {
        i * size + j
    }


    init(matrix: AdMatrix) {
        self.size = matrix.size
        
        var origin = BitMatrix(size: size, fill: .reverseIdentity)
        
        let template = BitMatrix(size: size, fill: .reverseIdentity)
        var buffer = Array<BitMatrix?>(repeating: nil, count: size * size)

        for a in 0..<size {
            for b in 0..<size where a != b {
                let j = a * size + b
                var set = template
                for c in 0..<size where c != a && c != b {
                    for d in 0..<size where d != a && d != b && d != c {
                        if matrix.isConflict(a: a, b: b, c: c, d: d) {
                            set[c, d] = false
                        }
                    }
                }

                for x in 0..<size {
                    set[x, b] = false
                }
                set[b, a] = false
                set[a] = 0
                
                let c = set[b].firstBitNotEmpty(size: size)
                let mask = set[c]
                let visited = UInt64(0).setBit(index: a).setBit(index: b).setBit(index: c)
                
                let isHorde = set.testConnectivity(mask: mask, visited: visited, count: size - 2)
                
                if isHorde {
                    buffer[j] = nil
                    origin[a, b] = false
                } else {
                    buffer[j] = set
                }
            }
        }

        self.base = origin
        self.array = buffer
    }
}

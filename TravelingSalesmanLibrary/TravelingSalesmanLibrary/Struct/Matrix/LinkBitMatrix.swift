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
    private let hordes: [Bool]

    @inline(__always)
    subscript(i: Int, j: Int) -> BitMatrix? {
        array[index(i, j)]
    }
    
    @inline(__always)
    func index(_ i: Int, _ j: Int) -> Int {
        i * size + j
    }
    
    @inline(__always)
    func isHord(_ i: Int, _ j: Int) -> Bool {
        hordes[index(i, j)]
    }

    init(matrix: UnsafeAdMatrix) {
        self.size = matrix.size
        
        var origin = BitMatrix(size: size, fill: .reverseIdentity)
        var matBuffer = Array<BitMatrix?>(repeating: nil, count: size * size)
        var horBuffer = Array<Bool>(repeating: false, count: size * size)

        for a in 0..<size {
            for b in 0..<size where a != b {
                let j = a * size + b
                var set = BitMatrix(size: size, fill: .reverseIdentity)
                for c in 0..<size where c != a && c != b {
                    for d in 0..<size where d != a && d != b && d != c {
                        if matrix.isNotPossibleCase(a: a, b: b, c: c, d: d) {
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
                let visited = UInt64(0).setBit(index: a).setBit(index: b).setBit(index: c)
                let mask = set[c].clearBit(index: a).clearBit(index: b)
                
                let isHorde = !set.testConnectivity(mask: mask, visited: visited, count: size - 2)
                
                matBuffer[j] = set
                horBuffer[j] = isHorde
                
                if isHorde {
                    origin[a, b] = false
                }
            }
        }

        self.base = origin
        self.array = matBuffer
        self.hordes = horBuffer
    }
    
    func possibleSteps() -> [Edge] {
        var result = [Edge]()

        for a in 0..<size {
            for b in 0..<size where a != b && !self.isHord(a, b) {
                result.append(Edge(a: a, b: b))
            }
        }
        
        return result
    }
    
    func dealocate() {
        for item in array {
            item?.deallocate()
        }
        self.base.deallocate()
    }
}

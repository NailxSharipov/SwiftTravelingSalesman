//
//  BruteForceCutSolution.swift
//  TravelingSalesmanLibrary
//
//  Created by Nail Sharipov on 27.04.2021.
//

public struct BruteForceCutSolution {

    private let matrix: AdMatrix
    private var minLen: Int = .max
    private let linkMatrix: LinkBitMatrix
    
    private var cache = [UInt64: SubPath]()
    
    private var pathMask: UInt64 = 0
    private var pathBMtx: BitMatrix
    private var pathCount: Int = 0
    private var rest: OpenLinkedList
    private var best: [Int] = []
    private var path: [Int]
    private var length = 0
    
    private var m0: Int = 0
    private var m1: Int = 0
    private var m2: Int = 0
    private var m3: Int = 0

    public static func minPath(matrix: AdMatrix) -> [Int] {
        var solution = BruteForceCutSolution(matrix: matrix)
        return solution.solve()
    }
    
    private init(matrix: AdMatrix) {
        self.matrix = matrix
        self.linkMatrix = LinkBitMatrix(matrix: matrix)
        self.path = [Int](repeating: 0, count: matrix.size)
        self.pathBMtx = self.linkMatrix.base
        self.rest = OpenLinkedList(count: matrix.size, isEmpty: false)
    }
    
    mutating func solve() -> [Int] {
        let n = matrix.size
        guard n > 3 else {
            return Array(0..<n)
        }
        let a = 0
        
        let capacity = n > 15 ? 2^13 : 2^(n - 2)
        
        cache.reserveCapacity(capacity)
        pathMask = pathMask.setBit(index: a)
        rest[a] = false
        path[pathCount] = a
        pathCount = 1
        next()
        
        debugPrint("m0: \(m0), m1: \(m1), m2: \(m2), m3: \(m3)")
        
        return best
    }
    
    mutating func next() {
        let n = matrix.size
        let index = pathCount - 1
        m0 += 1
        
        let a = path[0]
        let c = path[index]
        
        guard pathCount < n else {
            let last = matrix[c, a]
            let result = length + last
            if minLen > result {
                best = path
                minLen = result
            }
            return
        }

        guard minLen > length else {
            return
        }

        if index >= 1 {
            // test connectivity
            let b = path[index - 1]
            if let bcBMtx = linkMatrix[b, c] {
                let newBMtx = pathBMtx.intersect(map: bcBMtx)
                
                guard newBMtx.isConnected(index: 0) else {
                    m3 += 1
                    return
                }

                let factor = newBMtx.connectivityFactor(start: c, visited: pathMask)
                let validFactor = n - pathCount
                if factor != validFactor {
                    m1 += 1
                    return
                }

                self.pathBMtx = newBMtx
            } else {
                return
            }
            
            // test cache
            
            var j = pathCount - 3
            while j > 0 {
                let result = path.subSet(start: j, end: index - 1, matrix: matrix)
                let subPathMask = result.0
                let subPath = result.1
                if let cacheSubPath = cache[subPathMask] {
                    if cacheSubPath.length < subPath.length {
                        let a0 = path[j]
                        let cacheLen = matrix[a0, cacheSubPath.start] + matrix[cacheSubPath.end, c] + cacheSubPath.length
                        let currentLen = matrix[a0, subPath.start] + matrix[subPath.end, c] + subPath.length
                        
                        if cacheLen < currentLen {
                            m2 += 1
                            return
                        }
                    } else {
                        cache[subPathMask] = subPath
                    }
                } else {
                    cache[subPathMask] = subPath
                }
                j -= 1
            }
        }
        
        var d = rest.first
        
        let copyBMtx = pathBMtx
        
        while d != -1 {
            let iNode = rest.remove(index: d)
            pathMask = pathMask.setBit(index: d)
            let cd = matrix[c, d]
            path[pathCount] = d
            pathCount += 1
            length += cd

            next()

            length -= cd
            pathCount -= 1
            rest.add(node: iNode)
            pathMask = pathMask.clearBit(index: d)
            
            pathBMtx = copyBMtx
            
            d = iNode.next
        }

        return
    }
}

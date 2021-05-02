//
//  BruteForceSolution.swift
//  TravelingSalesmanLibrary
//
//  Created by Nail Sharipov on 27.04.2021.
//

public struct BruteForceSolution {

    private let matrix: AdMatrix
    private var minLen: Int = .max
    private let linkMatrix: LinkBitMatrix
    
    private var cache = [UInt64: SubPath]()
    
    private var pathMask: UInt64 = 0
    private var pathBMtx: BitMatrix
    private var rest: OpenLinkedList
    private var best: [Int]
    private var path: FixArray
    private var length = 0
    
    private var m0: Int = 0
    private var m1: Int = 0
    private var m2: Int = 0
    private var m3: Int = 0

    public static func minPath(matrix: AdMatrix) -> [Int] {
        var solution = BruteForceSolution(matrix: matrix)
        let result = solution.solve()
        solution.dealocate()
        return result
    }
    
    private init(matrix: AdMatrix) {
        self.matrix = matrix
        self.linkMatrix = LinkBitMatrix(matrix: matrix)
        self.path = FixArray(capacity: matrix.size)
        self.best = [Int](repeating: 0, count: matrix.size)
        self.pathBMtx = self.linkMatrix.base
        self.rest = OpenLinkedList(count: matrix.size)
    }
    
    private mutating func solve() -> [Int] {
        let n = matrix.size
        guard n > 3 else {
            return Array(0..<n)
        }
        let a = 0
        
        let capacity = n > 15 ? 2^13 : 2^(n - 2)
        
        cache.reserveCapacity(capacity)
        pathMask = pathMask.setBit(index: a)
        rest[a] = false
        path.append(a)
        _ = next()
        
        debugPrint("m0: \(m0), m1: \(m1), m2: \(m2), m3: \(m3)")
        
        return best
    }
    
    mutating func next() -> Bool {
        let n = matrix.size
        let index = path.count - 1
        m0 += 1
        
        let a = path[0]
        let c = path[index]
        
        guard path.count < n else {
            let last = matrix[c, a]
            let result = length + last
            if minLen > result {
                path.fill(buffer: &best)
                minLen = result
            }
            return false
        }

        guard minLen > length else {
            return false
        }

        if index >= 1 {
            // test connectivity
            let b = path[index - 1]
            if let bcBMtx = linkMatrix[b, c] {
                let newBMtx = pathBMtx.intersect(map: bcBMtx)
                
                guard newBMtx.isConnected(index: 0) else {
                    m3 += 1
                    newBMtx.deallocate()
                    return false
                }

                let factor = newBMtx.connectivityFactor(start: c, visited: pathMask)
                let validFactor = n - path.count
                guard factor == validFactor else {
                    m1 += 1
                    newBMtx.deallocate()
                    return false
                }

//                self.pathBMtx.deallocate()
                
                self.pathBMtx = newBMtx
            } else {
                return false
            }
            
            // test cache

            var j = path.count - 3
            let end = j < 10 ? 0 : j - 10
            while j > end {
                let result = path.subSet(start: j, end: index - 1, matrix: matrix)
                let subPathMask = result.0
                let subPath = result.1
                if let cacheSubPath = cache[subPathMask] {
                    if cacheSubPath.length < subPath.length {
                        let a0 = path[j]
                        let cacheLen = matrix[a0, cacheSubPath.start] + matrix[cacheSubPath.end, c] + cacheSubPath.length
                        let currentLen = matrix[a0, subPath.start] + matrix[subPath.end, c] + subPath.length

                        guard cacheLen >= currentLen else {
                            m2 += 1
                            return true
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
            path.append(d)
            length += cd

            if next() {
                pathBMtx.deallocate()
            }

            length -= cd
            path.removeLast()
            rest.add(node: iNode)
            pathMask = pathMask.clearBit(index: d)

            pathBMtx = copyBMtx
            
            d = iNode.next
        }

        return true
    }
    
    private func dealocate() {
        self.linkMatrix.dealocate()
        self.path.dealocate()
        self.rest.dealocate()
//        self.pathBMtx.deallocate()
    }
}

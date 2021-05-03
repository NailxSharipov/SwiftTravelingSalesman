//
//  BruteForceSolution.swift
//  TravelingSalesmanLibrary
//
//  Created by Nail Sharipov on 27.04.2021.
//

public struct BruteForceSolution {

    private let matrix: UnsafeAdMatrix
    private let linkMatrix: LinkBitMatrix
    private let bitMtxBuffer: UnsafeMutablePointer<BitMatrix>
    
    private var minLen: Int = .max
    private var cache = [UInt64: SubPath]()
    
    private var pathMask: UInt64 = 0
    private var pathBMtx: BitMatrix
    private var rest: UnsafeIntList
    private var best: [Int]
    private var path: UnsafeArray<Int>
    private var pathLength = 0
    
    private var m0: Int = 0
    private var m1: Int = 0
    private var m2: Int = 0
    private var m3: Int = 0
    private var m4: Int = 0

    public static func minPath(matrix: AdMatrix) -> [Int] {
        var solution = BruteForceSolution(matrix: matrix)
        let result = solution.solve()
        solution.dealocate()
        return result
    }
    
    private func dealocate() {
        self.matrix.dealocate()
        self.linkMatrix.dealocate()
        self.path.dealocate()
        self.rest.dealocate()
        
        for i in 0..<matrix.size {
            self.bitMtxBuffer[i].deallocate()
        }
        
        self.bitMtxBuffer.deinitialize(count: matrix.size)
        self.bitMtxBuffer.deallocate()
    }
    
    private init(matrix: AdMatrix) {
        self.matrix = UnsafeAdMatrix(matrix: matrix)
        self.linkMatrix = LinkBitMatrix(matrix: self.matrix)
        self.path = UnsafeArray<Int>(capacity: matrix.size)
        self.best = [Int](repeating: 0, count: matrix.size)
        self.pathBMtx = self.linkMatrix.base
        self.rest = UnsafeIntList(count: matrix.size)
        self.bitMtxBuffer = UnsafeMutablePointer<BitMatrix>.allocate(capacity: matrix.size)
        for i in 0..<matrix.size {
            self.bitMtxBuffer[i] = BitMatrix(size: matrix.size)
        }
    }
    
    private mutating func solve() -> [Int] {
        let n = matrix.size
        guard n > 3 else {
            return Array(0..<n)
        }
        let a = 0
        
        let capacity = n > 15 ? 1 << 13 : 1 << (n - 2)
        
        cache.reserveCapacity(capacity)
        pathMask = pathMask.setBit(index: a)
        rest[a] = false
        path.append(a)
        next()
        
//        debugPrint("m0: \(m0), m1: \(m1), m2: \(m2), m3: \(m3), m4: \(m4)")
        
        return best
    }
    
    mutating func next() {
        let n = matrix.size
        let index = path.count - 1
        m0 += 1
        
        let a = path[0]
        let c = path[index]
        
        guard path.count < n else {
            let last = matrix[c, a]
            let result = pathLength + last
            if minLen > result {
                path.fill(buffer: &best)
                minLen = result
                m4 += 1
            }
            return
        }

        guard minLen > pathLength else {
            return
        }

        if index >= 1 {
            // test connectivity
            let b = path[index - 1]
            if let bcBMtx = linkMatrix[b, c] {
                var newBMtx = bitMtxBuffer[index]
                pathBMtx.intersect(map: bcBMtx, result: &newBMtx)
                
                guard newBMtx.isConnected(index: 0) else {
                    m3 += 1
                    return
                }

                let factor = newBMtx.connectivityFactor(start: c, visited: pathMask)
                let validFactor = n - path.count
                guard factor == validFactor else {
                    m1 += 1
                    return
                }
                
                self.pathBMtx = newBMtx
            } else {
                return
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
            path.append(d)
            pathLength += cd

            next()

            pathLength -= cd
            path.removeLast()
            rest.add(node: iNode)
            pathMask = pathMask.clearBit(index: d)

            pathBMtx = copyBMtx
            
            d = iNode.next
        }

        return
    }

}

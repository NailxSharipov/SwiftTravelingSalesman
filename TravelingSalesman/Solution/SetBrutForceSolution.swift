//
//  SetBrutForceSolution.swift
//  TravelingSalesman
//
//  Created by Nail Sharipov on 30.03.2021.
//

struct SetBrutForceSolution {
    
    private let matrix: AdMatrix
    private let edgeMatrix: EdgeMatrix
    private var minLen: Int = .max
    private var best: [Int] = []
    private var path: [Int] = []
    
    private var length = 0
    private var m0 = 0
    private var m1 = 0

    static func minPath(matrix: AdMatrix) -> [Int] {
        var solution = SetBrutForceSolution(matrix: matrix)
        solution.solve()
        return solution.best
    }
    
    init(matrix: AdMatrix) {
        self.matrix = matrix
        self.edgeMatrix = EdgeMatrix(matrix: matrix)
        self.path.reserveCapacity(matrix.size)
    }

    mutating private func solve() {
        let n = matrix.size
        guard n > 3 else {
            self.path = Array(0..<n)
            return
        }

        let emptySet = EdgeSet(size: n, isOptimal: true)
        
        let a = 0
        self.path.append(a)
        
        for b in 1..<n {
            self.path.append(b)
            length += matrix[a, b]
            self.next(edgeSet: emptySet)
            self.path.removeLast()
            length -= matrix[a, b]
        }
        
//        debugPrint("m0: \(m0) m1: \(m1)")
    }
    
    mutating private func next(edgeSet: EdgeSet) {
        let n = matrix.size
        let index = path.count - 1
        guard path.count + 2 < n else {
            finish(rest: edgeSet.rest)
            return
        }

        guard minLen > length, edgeSet.count > 0 else {
            return
        }

        var nextEdgeSet = edgeSet
//        debugPrint("path: \(path)")
//        debugPrint("before:")
//        debugPrint(nextEdgeSet)
        

        let p0 = path[index - 1]
        let p1 = path[index]
        let set = edgeMatrix[p0, p1]
//        debugPrint("subtract: (\(p0)-\(p1))")
//        debugPrint(set)

        nextEdgeSet.subtract(set: set)
        nextEdgeSet.remove(a: p1, ends: self.path)
        
//        debugPrint("after:")
//        debugPrint(nextEdgeSet)
//        debugPrint("-------")
        
        let edgesCount = nextEdgeSet.edgesCount
        let stepsToEnd = n - path.count + 1
        
//        debugPrint("edgesCount: \(edgesCount), stepsToEnd: \(stepsToEnd)")
        
        guard edgesCount >= stepsToEnd else {
            m0 += 1
            return
        }
        
        guard nextEdgeSet.isAllConnective else {
            m1 += 1
            return
        }
        
        
        let b = path[index]
        let list = nextEdgeSet[b]
        if list.count > 0 {
            let values = list.values
//            debugPrint("values:")
//            debugPrint(values)
            for c in values {
                let bc = matrix[b, c]

                self.path.append(c)
                length += bc

                next(edgeSet: nextEdgeSet)

                length -= bc
                self.path.removeLast()
            }
        }

        return
    }
    
    mutating private func finish(rest: [Int]) {
        assert(rest.count <= 4)
        var set = Set(rest)
        var result = [Int]()
        result.reserveCapacity(2)
        for p in path {
            set.remove(p)
        }
        let c = set.popFirst()!
        let d = set.popFirst()!
        
        self.finish(c, d)
    }
    
    mutating private func finish(_ c: Int, _ d: Int) {
        let b = path[0]
        let a = path[path.count - 1]

        let acdb = matrix[a, c] + matrix[c, d] + matrix[d, b]
        let adcb = matrix[a, d] + matrix[d, c] + matrix[c, b]
        
        if acdb < adcb {
            if acdb + length < minLen {
                best = path + [c, d]
                minLen = acdb + length
            }
        } else {
            if adcb + length < minLen {
                best = path + [d, c]
                minLen = adcb + length
            }
        }
    }
    
}

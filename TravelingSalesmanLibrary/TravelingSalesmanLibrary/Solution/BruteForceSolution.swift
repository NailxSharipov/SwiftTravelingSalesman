//
//  BruteForceSolution.swift
//  TravelingSalesmanLibrary
//
//  Created by Nail Sharipov on 15.04.2021.
//

public struct BruteForceSolution {

    private let matrix: AdMatrix
    private var minLen: Int = .max
    private var set0: OpenLinkedList
    private var set1: Set<Int>
    private var best: [Int] = []
    private var path: [Int] = []
    private var length = 0
    
    private var m0: Int = 0
    private var m1: Int = 0
    private var m2: Int = 0
    private var m3: Int = 0
    private var m4: Int = 0

    public static func minPath(matrix: AdMatrix) -> [Int] {
        var solution = BruteForceSolution(matrix: matrix)
        return solution.solve()
    }
    
    private init(matrix: AdMatrix) {
        self.matrix = matrix
        self.set0 = OpenLinkedList(count: matrix.size, isEmpty: false)
        self.set1 = Set<Int>(set0.path)
    }
    
    mutating func solve() -> [Int] {
        let n = matrix.size
        guard n > 3 else {
            return Array(0..<n)
        }
        path.reserveCapacity(n)
        let a = 0
        set0[a] = false
        set1.remove(a)
        path.append(a)
        next()
        
        return best
    }
    
    mutating func next() {
        let n = matrix.size
        let index = path.count - 1
        m0 += 1
        
        guard path.count < n else {
            let last = matrix[path[index], path[0]]
            let result = length + last
            if minLen > result {
                best = path
                minLen = result
            }
            return
        }
        
        guard minLen > length else {
            m4 += 1
            return
        }
        

        let d = path[index]
        
        if path.count > 3 {
            let cIndex = index - 1
            let eIndex = index - 2
            
            let e = path[eIndex]
            let c = path[cIndex]
            let cd = matrix[c, d]
            let ecd = matrix[c, e] + matrix[c, d] - matrix[e, d]

            var a = path[0]
            for i in 1..<cIndex {
                let b = path[i]

                let ab = matrix[a, b]
                let ac = matrix[a, c]
                
                // remove unoptimal more optimal
                let acb = ac + matrix[b, c] - ab
                if acb < ecd {
                    m1 += 1
                    return
                }

                let bd = matrix[b, d]

                // remove self intersections
                if ab + cd > ac + bd {
                    m2 += 1
                    return
                }
                
                a = b
            }
        }
        
        let newSet: Set<Int>
        if index > 1 {
            newSet = Self.fillBackPathExist(a: path[0], c: path[index - 1], d: path[index], set: set1, matrix: matrix)
            if newSet.count == set1.count {
                m3 += 1
                return
            } else {
                set1.subtract(newSet)
            }
        } else {
            newSet = Set<Int>()
        }
        
        var i = set0.first
        
        while i != -1 {
            let i0Node = set0.remove(index: i)
            set1.remove(i)
            let de = matrix[d, i]
            path.append(i)
            length += de
            next()
            length -= de
            path.removeLast()
            set0.add(node: i0Node)
            
            set1.insert(i)
            
            i = i0Node.next
        }

        if !newSet.isEmpty {
            set1.formUnion(newSet)
        }
        
        return
    }
    
    private static func fillBackPathExist(a: Int, c: Int, d: Int, set: Set<Int>, matrix: AdMatrix) -> Set<Int> {
        var unreturnable = Set<Int>()
        for i in set {
            if matrix.isNotPossibleCase(a: i, b: a, c: c, d: d) {
                unreturnable.insert(i)
            }
        }
        
        return unreturnable
    }
}

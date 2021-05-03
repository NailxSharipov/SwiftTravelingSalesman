//
//  SurfaceSplitSolution.swift
//  TravelingSalesmanLibrary
//
//  Created by Nail Sharipov on 15.04.2021.
//

public struct SurfaceSplitSolution {

    private let matrix: UnsafeAdMatrix
    private let linkMatrix: LinkBitMatrix
    private var minLen: Int = .max
    
    public struct Info {
        public let dots: [Dot]
        public let hordes: [Edge]
        public let steps: [Edge]
        public let path: [Int]
    }
    
    public struct Dot {
        public let index: Int
        public let description: String
    }
    
    public static func info(matrix: AdMatrix) -> Info {
        let solution = SurfaceSplitSolution(matrix: matrix)
        return solution.info()
    }
    
    private init(matrix: AdMatrix) {
        self.matrix = UnsafeAdMatrix(matrix: matrix)
        self.linkMatrix = LinkBitMatrix(matrix: self.matrix)
    }
    
    func info() -> Info {
        let steps = linkMatrix.possibleSteps()
        var dots = [Dot]()
        for i in 0..<matrix.size {
            dots.append(Dot(index: i, description: "\(i)"))
        }

        let path = self.findCircle()
        
        return Info(dots: dots, hordes: [], steps: steps, path: path)
    }
    
    
    func findCircle() -> [Int] {
        guard var path = self.findFirstTriple() else {
            return []
        }
        let n = matrix.size

        let a = path[0]
        var b = path[path.count - 2]
        var c = path[path.count - 1]
        
        var visited = UInt64(mask: path)
        
        var pathMat = linkMatrix[a, b]!.intersect(map: linkMatrix[b, c]!)

        var isEnd = true
        
        repeat {
            isEnd = true
            let roads = pathMat[c]
            for d in 0..<n {
                if roads.isBit(index: d) && !visited.isBit(index: d) {
                    if let bdMat = linkMatrix[b, d] {
                        let mat = pathMat.intersect(map: bdMat)
                        if mat.isClosed(index: c, a: b, b: d) {
                            visited = visited.setBit(index: d)
                            path.append(d)
                            b = c
                            c = d
                            let cdMat = linkMatrix[b, d]!
                            pathMat = pathMat.intersect(map: cdMat)
                            isEnd = false
                            break
                        }
                    }
                }
            }
        } while !isEnd
        
        return path
    }
    
    private func findFirstTriple() -> [Int]? {
       
        let n = matrix.size

        for a in 0..<n {
            for b in 0..<n where a != b && !linkMatrix.isHord(a, b) {
                for c in 0..<n where b != c && c != a && linkMatrix.isHord(a, c) {
                    let acMat = linkMatrix[a, c]!
                    if acMat.isClosed(index: b, a: a, b: c) {
                        return [a, b, c]
                    }
                }
            }
        }
        
        return nil
    }
    
}

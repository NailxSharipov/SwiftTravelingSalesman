//
//  SurfaceSplitSolution.swift
//  TravelingSalesmanLibrary
//
//  Created by Nail Sharipov on 15.04.2021.
//

public struct SurfaceSplitSolution {

    private let matrix: AdMatrix
    private var minLen: Int = .max

    public static func minPath(matrix: AdMatrix) -> [Int] {
        var solution = SurfaceSplitSolution(matrix: matrix)
        return solution.solve()
    }
    
    private init(matrix: AdMatrix) {
        self.matrix = matrix
    }
    
    mutating func solve() -> [Int] {
        let n = matrix.size
        guard n > 3 else {
            return Array(0..<n)
        }

        
        return []
    }
}

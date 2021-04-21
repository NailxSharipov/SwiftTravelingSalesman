//
//  SurfaceSplitSolution.swift
//  TravelingSalesmanLibrary
//
//  Created by Nail Sharipov on 15.04.2021.
//

public struct SurfaceSplitSolution {

    private let matrix: AdMatrix
    private let edgeMatrix: EdgeMatrix
    private var minLen: Int = .max

//    public static func minPath(matrix: AdMatrix) -> [Edge] {
//        var solution = SurfaceSplitSolution(matrix: matrix)
//        return solution.solve()
//    }
//
    public static func hordes(matrix: AdMatrix) -> [Edge] {
        let solution = SurfaceSplitSolution(matrix: matrix)
        return solution.edgeMatrix.impossibleHordes()
    }
    
    public struct Info {
        public let dots: [Dot]
        public let hordes: [Edge]
        public let steps: [Edge]
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
        self.matrix = matrix
        self.edgeMatrix = EdgeMatrix(matrix: matrix)
    }
    
    func info() -> Info {
//        let hordes = edgeMatrix.impossibleHordes()
        let steps = edgeMatrix.possibleSteps()
        var dots = [Dot]()
        for i in 0..<matrix.size {
            dots.append(Dot(index: i, description: "\(i)"))
        }

        return Info(dots: dots, hordes: [], steps: steps)
    }
    
}

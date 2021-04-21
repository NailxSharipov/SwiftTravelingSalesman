//
//  GraphReformationSolution.swift
//  TravelingSalesmanLibrary
//
//  Created by Nail Sharipov on 17.04.2021.
//

public struct GraphReformationSolution {

    private let matrix: AdMatrix
    private let edgeMatrix: EdgeMatrix
    private let reform: [Int]
    
    public struct Info {
        public let cities: [City]
    }
    
    public struct Dot {
        public let index: Int
        public let description: String
    }
    
    public static func info(matrix: AdMatrix, reform: [Int]) -> Info {
        let solution = GraphReformationSolution(matrix: matrix, reform: reform)
        return solution.info()
    }
    
    private init(matrix: AdMatrix, reform: [Int]) {
        self.matrix = matrix
        self.reform = reform
        self.edgeMatrix = EdgeMatrix(matrix: matrix)
    }
    
    func info() -> Info {
//        let steps = edgeMatrix.possibleSteps()
//
//        var cityMap = [City]()
//
//        for step in steps {
//            let length = matrix[step.a, step.b]
//            let road = Road(length: length, path: [Int8(step.a), Int8(step.b)])
//            if var city = cityMap[step.a] {
//                city.roads.append(road)
//                cityMap[step.a] = city
//            } else {
//                cityMap[step.a] = City(index: step.a, roads: [road], neighbours: FixSizeSet(size: matrix.size))
//            }
//
//            if var neighbour = cityMap[step.b] {
//                neighbour.neighbours.add(index: step.a)
//                cityMap[step.b] = neighbour
//            } else {
//                var neighbours = FixSizeSet(size: matrix.size)
//                neighbours.add(index: step.a)
//                cityMap[step.b] = City(index: step.b, roads: [], neighbours: neighbours)
//            }
//        }
//
//        return Info(cities: Array(cityMap.values))
        
        let linkMatrix = LinkBitMatrix(matrix: matrix)

        
        
        var cityMap = [City]()
        for i in 0..<matrix.size {
            let city = City(index: i, size: matrix.size)
            cityMap.append(city)
        }
        
        return Info(cities: cityMap)
    }
    
}

public extension City {

    var description: String {
        "\(self.index) (\(roads.count))"
    }
}

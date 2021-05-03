//
//  GraphReformationSolution.swift
//  TravelingSalesmanLibrary
//
//  Created by Nail Sharipov on 17.04.2021.
//

public struct GraphReformationSolution {

    private let matrix: UnsafeAdMatrix
    
    public struct Info {
        public let cities: [City]
    }
    
    public struct Dot {
        public let index: Int
        public let description: String
    }
    
    public static func info(matrix: AdMatrix, removed: [Int]) -> Info {
        let solution = GraphReformationSolution(matrix: matrix)
        let info = solution.info(removed: removed)
        solution.dealocate()
        return info
    }
    
    private init(matrix: AdMatrix) {
        self.matrix = UnsafeAdMatrix(matrix: matrix)
    }
    
    private func dealocate() {
        self.matrix.dealocate()
    }
    
    func info(removed: [Int]) -> Info {
        let linkMatrix = LinkBitMatrix(matrix: matrix)
        let baseMovement = linkMatrix.base
        
        let count = linkMatrix.size

        var outRoadMap = [[Road]]()
        outRoadMap.reserveCapacity(count)
        var inRoadMap: [[Road]] = [[Road]](repeating: [], count: count)
        
        for a in 0..<count {
            
            var aRoads = [Road]()
            for b in 0..<linkMatrix.size {
                if let roadBitMatrix = linkMatrix[a, b] {
                    let ab = matrix[a, b]
                    let movement = baseMovement.intersect(map: roadBitMatrix)
                    let road = Road(length: ab, path: [a, b], movement: movement)
                    aRoads.append(road)
                }
            }
            outRoadMap.append(aRoads)
            for road in aRoads {
                let b = Int(road.path[1])
                var inRoads = inRoadMap[b]
                inRoads.append(road)
                inRoadMap[b] = inRoads
            }
        }
        
        var cities = [City]()
        cities.reserveCapacity(count)
        
        for i in 0..<count {
            cities.append(City(index: i, outRoads: outRoadMap[i], inRoads: inRoadMap[i]))
        }

        // city не нужен

        var roadByMask = [RoadMask: Road]()
        roadByMask.reserveCapacity(count * count)

        for index in removed {
            let city = cities[index]
            city.isRemoved = true
            
            roadByMask.removeAll(keepingCapacity: true)
            
            for inRoad in city.inRoads {
                for outRoad in city.outRoads where inRoad.a != outRoad.b {

                    inRoad.isRemoved = true
                    outRoad.isRemoved = true

                    let aCity = cities[inRoad.a]
                    aCity.isInDirty = true
                    
                    let bCity = cities[outRoad.b]
                    bCity.isOutDirty = true

                    if let newRoad = Road(inRoad: inRoad, outRoad: outRoad) {
                        if let maskRoad = roadByMask[newRoad.mask] {
                            if maskRoad.length > newRoad.length {
                                roadByMask[newRoad.mask] = newRoad
                                maskRoad.isRemoved = true
                            } else {
                                continue
                            }
                        }

                        aCity.outRoads.append(newRoad)
                        bCity.inRoads.append(newRoad)
                    }
                }
            }
            
            for city in cities {
                if city.isInDirty {
                    city.inRoads = city.inRoads.filter({ !$0.isRemoved })
                    city.isInDirty = false
                }
                if city.isOutDirty {
                    city.outRoads = city.outRoads.filter({ !$0.isRemoved })
                    city.isOutDirty = false
                }
            }
        }

        return Info(cities: cities)
    }
    
}

public extension City {

    var description: String {
        "\(self.index) (\(outRoads.count))"
    }
}

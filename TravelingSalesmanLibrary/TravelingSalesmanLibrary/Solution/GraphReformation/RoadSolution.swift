//
//  RoadSolution.swift
//  TravelingSalesmanLibrary
//
//  Created by Nail Sharipov on 25.04.2021.
//

public struct RoadSolution {

    private let matrix: UnsafeAdMatrix
    
    public struct Info {
        public let cities: [City]
    }
    
    public struct Dot {
        public let index: Int
        public let description: String
    }

    public static func solve(matrix: AdMatrix) -> [Int] {
        let matrix = UnsafeAdMatrix(matrix: matrix)
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
        
        matrix.dealocate()
        
        var cities = [City]()
        cities.reserveCapacity(count)
        
        for i in 0..<count {
            cities.append(City(index: i, outRoads: outRoadMap[i], inRoads: inRoadMap[i]))
        }
        
        var roadByMask = [RoadMask: Road]()
        roadByMask.reserveCapacity(count * count)
        
        for index in 2..<count {
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

//        let lastCity = cities[0]
        var minPath = [Int](repeating: 0, count: count)
        var minLength = Int.max
        
        let cityA = cities[0]
        let cityB = cities[1]
        
        let allMask: UInt64 = ((1 << count) &- 1) - 0b11
        
        for ab in cityA.outRoads {
            let abMask = ab.mask
            
            for ba in cityB.outRoads {
                let baMask = ba.mask
                let pathCount = ab.path.count + ba.path.count - 2
                let pathLength = ab.length + ba.length
                let pathMask = abMask.subMask | baMask.subMask
                if pathMask == allMask && pathCount == count && pathLength < minLength {
                    minLength = pathLength

                    for i in 0..<ab.path.count {
                        minPath[i] = ab.path[i]
                    }
                    var j = ab.path.count
                    for i in 1..<ba.path.count - 1 {
                        minPath[j] = ba.path[i]
                        j &+= 1
                    }
                }
            }
        }
        
//        for road in lastCity.outRoads where road.path.count == count {
//            if road.length < minLength {
//                minLength = road.length
//                minPath = road.path
//            }
//        }
        
//        for inRoad in lastCity.inRoads {
//            for outRoad in lastCity.outRoads {
//                let aMask = inRoad.mask
//                let bMask = outRoad.mask
//                let abCount = inRoad.path.count + outRoad.path .count - 2
//                let abLength = inRoad.length + outRoad.length
//                if aMask.bitMask & bMask.bitMask == 0 && abCount == count && abLength < minLength {
//                    minLength = abLength
//
//                    for i in 0..<inRoad.path.count {
//                        minPath[i] = inRoad.path[i]
//                    }
//                    var j = inRoad.path.count
//                    for i in 1..<outRoad.path.count - 1 {
//                        minPath[j] = outRoad.path[i]
//                        j &+= 1
//                    }
//                }
//            }
//        }

        return minPath
    }
    
}

//
//  RoadSolution.swift
//  TravelingSalesmanLibrary
//
//  Created by Nail Sharipov on 25.04.2021.
//

public final class RoadSolution {

    private let matrix: UnsafeAdMatrix
    private let linkMatrix: LinkBitMatrix
    private var roadPull: RoadPull
    private var max: Int = 0
    
    public struct Info {
        public let cities: [City]
    }
    
    public static func minPath(matrix: AdMatrix) -> [Int] {
        let solution = RoadSolution(matrix: matrix)
        let result = solution.solve()
        solution.dealocate()
        return result
    }
    
    private init(matrix: AdMatrix) {
        self.matrix = UnsafeAdMatrix(matrix: matrix)
        self.linkMatrix = LinkBitMatrix(matrix: self.matrix)
        let n = matrix.size
        self.roadPull = RoadPull(initCapacity: n * n, count: n)
    }
    
    private func dealocate() {
        matrix.dealocate()
        linkMatrix.dealocate()
        roadPull.dealocate()
    }

    private func solve() -> [Int] {

        var cities = self.createCities()
        self.clearCities(cities: &cities)

        let count = linkMatrix.size

        var minPath = [Int](repeating: 0, count: count)
        var minLength = Int.max
        
        let cityA = cities[0]
        let cityB = cities[1]
        
        let allMask: UInt64 = ((1 << count) &- 1) - 0b11
        
        for abIndex in 0..<cityA.outRoads.count {
            let abId = cityA.outRoads[abIndex]
            let ab = roadPull[abId]
            let abMask = ab.mask
            
            for baIndex in 0..<cityB.outRoads.count {
                let baId = cityB.outRoads[baIndex]
                let ba = roadPull[baId]
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
        
        for index in 0..<count {
            cities[index].dealocate()
        }
        
        cities.dealocate()

        return minPath
    }
    
    private func createCities() -> UnsafeList<ReusableCity> {
        let baseMovement = linkMatrix.base
        
        let count = linkMatrix.size

        var outRoadMap = [[Int]]()
        outRoadMap.reserveCapacity(count)
        var inRoadMap: [[Int]] = [[Int]](repeating: [], count: count)
        
        for a in 0..<count {
            var aRoads = [Int]()
            for b in 0..<linkMatrix.size where a != b && !linkMatrix.isHord(a, b) {
                if let roadBitMatrix = linkMatrix[a, b] {
                    let ab = matrix[a, b]
                    var road = roadPull.getFree()
                    baseMovement.intersect(map: roadBitMatrix, result: &road.movement)
                    road.length = ab
                    road.path.append(a)
                    road.path.append(b)
                    road.mask = RoadMask(a: a, b: b, subMask: 0)
                    roadPull[road.id] = road

                    aRoads.append(road.id)
                }
            }
            outRoadMap.append(aRoads)
            for roadId in aRoads {
                let road = roadPull[roadId]
                let b = road.b
                var inRoads = inRoadMap[b]
                inRoads.append(roadId)
                inRoadMap[b] = inRoads
            }
        }
        
        var cities = UnsafeList<ReusableCity>(capacity: count)
        
        for i in 0..<count {
            cities.append(ReusableCity(outRoads: outRoadMap[i], inRoads: inRoadMap[i]))
        }
        
        return cities
    }
    
    private func clearCities(cities: inout UnsafeList<ReusableCity>) {
        let count = linkMatrix.size
        
        var bestRoads = [RoadMask: ReusableRoad]()
        bestRoads.reserveCapacity(count * count)
        
        var roadBufferA = UnsafeList<ReusableRoad>(capacity: count * count * count)
        var roadBufferB = UnsafeList<ReusableRoad>(capacity: count * count * count)
        
        for index in 2..<count {
            let city = cities[index]

            roadBufferA.removeAll()
            var j = 0
            while j < city.inRoads.count {
                let roadId = city.inRoads[j]
                let road = roadPull[roadId]
                roadPull.addRemoved(id: roadId)
                roadBufferA.append(road)
                j &+= 1
            }
            
            roadBufferB.removeAll()
            j = 0
            while j < city.outRoads.count {
                let roadId = city.outRoads[j]
                let road = roadPull[roadId]
                roadPull.addRemoved(id: roadId)
                roadBufferB.append(road)
                j &+= 1
            }
            
            var inIndex = 0
            while inIndex < roadBufferA.count {
                let inRoad = roadBufferA[inIndex]
                let a = inRoad.a
                var outIndex = 0
                while outIndex < roadBufferB.count {
                    let outRoad = roadBufferB[outIndex]
                    let b = outRoad.b
                    if a != b {
                        if merge(inRoad: inRoad, outRoad: outRoad) {
                            if let prevBestRoad = bestRoads[roadPull.tempRoad.mask] {
                                if prevBestRoad.length > roadPull.tempRoad.length {
                                    let newRoad = roadPull.pushTempRoad()
                                    bestRoads[newRoad.mask] = newRoad
                                    roadPull.release(prevBestRoad.id)
//                                } else {
//                                    roadPull.release(newRoad.id)
                                }
                            } else {
                                let newRoad = roadPull.pushTempRoad()
                                bestRoads[newRoad.mask] = newRoad
                            }
                        }
                    }
                    
                    outIndex &+= 1
                }
                
                inIndex &+= 1
            }

            for index in 0..<city.inRoads.count {
                let roadId = city.inRoads[index]
                roadPull.release(roadId)
            }
            
            for index in 0..<city.outRoads.count {
                let roadId = city.outRoads[index]
                roadPull.release(roadId)
            }

            for i in 0..<count {
                var city = cities[i]
                city.clearInRoads(roadPull: roadPull)
                city.clearOutRoads(roadPull: roadPull)
                cities[i] = city
            }

            roadPull.clearAllRemoved()
            
            for road in bestRoads.values {
                var aCity = cities[road.a]
                aCity.outRoads.append(road.id)
                cities[road.a] = aCity
                
                var bCity = cities[road.b]
                bCity.inRoads.append(road.id)
                cities[road.b] = bCity
            }
            
            if max < bestRoads.count {
                max = bestRoads.count
                debugPrint(max)
            }
            
            bestRoads.removeAll(keepingCapacity: true)
        }
        
        roadBufferA.dealocate()
        roadBufferB.dealocate()
    }
    
    
    private func merge(inRoad: ReusableRoad, outRoad: ReusableRoad) -> Bool {
        let inMask = inRoad.mask
        let outMask = outRoad.mask
        guard inMask.subMask & outMask.subMask == 0, !(inMask.a == outMask.b && inMask.b == outMask.a) else {
            return false
        }

        var newRoad = self.roadPull.tempRoad //self.roadPull.getFree()
        newRoad.prepare()
        
        inRoad.movement.intersect(map: outRoad.movement, result: &newRoad.movement)

        let n = inRoad.path.count + outRoad.path.count - 1
        
        newRoad.path.replace(inRoad.path.buffer, count: inRoad.path.count)

        for i in 1..<outRoad.path.count {
            newRoad.path.append(outRoad.path[i])
        }

        let a = inMask.a
        let b = outMask.b
        let subMask = inMask.subMask | outMask.subMask | (1 << inMask.b)
        let visited = subMask.setBit(index: a).setBit(index: b)
        
        let factor = newRoad.movement.connectivityFactor(start: outMask.b, visited: visited)
        let size = newRoad.movement.count
        let validFactor = size - n
        let isHorde = factor != validFactor

        if isHorde {
            return false
        } else {
            newRoad.mask = RoadMask(a: a, b: b, subMask: subMask)
            newRoad.length = inRoad.length &+ outRoad.length
            self.roadPull.tempRoad = newRoad
//            self.roadPull[newRoad.id] = newRoad
            
            return true
        }
    }
    
}

private extension UInt64 {
    
    init(mask: UnsafeArray<Int>) {
        var a: UInt64 = 0
        var i = 0
        while i < mask.count {
            let bit = mask[i]
            a = a | (1 << bit)
            i &+= 1
        }
        self = a
    }

}

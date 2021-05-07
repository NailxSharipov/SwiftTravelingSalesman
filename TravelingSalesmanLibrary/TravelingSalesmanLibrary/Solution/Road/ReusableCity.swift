//
//  ReusableCity.swift
//  TravelingSalesmanLibrary
//
//  Created by Nail Sharipov on 04.05.2021.
//

struct ReusableCity {

    var outRoads: UnsafeList<Int>
    var inRoads: UnsafeList<Int>
    
    init(outRoads: [Int], inRoads: [Int]) {
        self.outRoads = UnsafeList<Int>(array: outRoads)
        self.inRoads = UnsafeList<Int>(array: inRoads)
    }
    
    @inline(__always)
    mutating func clearInRoads(roadPull: RoadPull) {
        var newRoads = UnsafeList<Int>(capacity: inRoads.capacity)
        for i in 0..<inRoads.count {
            let roadId = inRoads[i]
            if !roadPull.isRemoved(id: roadId) {
                newRoads.append(roadId)
            }
        }
        inRoads.dealocate()
        inRoads = newRoads
    }
    
    @inline(__always)
    mutating func clearOutRoads(roadPull: RoadPull) {
        var newRoads = UnsafeList<Int>(capacity: outRoads.capacity)
        for i in 0..<outRoads.count {
            let roadId = outRoads[i]
            if !roadPull.isRemoved(id: roadId) {
                newRoads.append(roadId)
            }
        }
        outRoads.dealocate()
        outRoads = newRoads
    }
    
    func dealocate() {
        outRoads.dealocate()
        inRoads.dealocate()
    }
    
}

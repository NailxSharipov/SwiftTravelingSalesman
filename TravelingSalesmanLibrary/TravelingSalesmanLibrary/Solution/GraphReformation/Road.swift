//
//  Road.swift
//  TravelingSalesmanLibrary
//
//  Created by Nail Sharipov on 17.04.2021.
//

public struct RoadMask: Hashable {
    
    let a: Int
    let b: Int
    let subMask: UInt64
    
    @inline(__always)
    init(path: [Int]) {
        let n = path.count
        var m: UInt64 = 0
        for i in 0..<n {
            let j = path[i]
            m = m | (1 << j)
        }
        self.a = path[0]
        self.b = path[n - 1]
        self.subMask = m.clearBit(index: a).clearBit(index: b)
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(subMask)
    }

}

public final class Road {
    
    public let path: [Int]
    public let length: Int
    public let mask: RoadMask
    let movement: BitMatrix
    var isRemoved: Bool = false
    
    @inline(__always)
    public var a: Int {
        mask.a
    }
    
    @inline(__always)
    public var b: Int {
        mask.b
    }
    
    @inline(__always)
    public var description: String? {
        let n = path.count
        guard n > 2 else { return nil }
        return path[1..<n - 1].map({ String($0) }).joined(separator: "-")
    }
    
    init(length: Int, path: [Int], movement: BitMatrix) {
        self.length = length
        self.path = path
        self.movement = movement
        self.mask = RoadMask(path: path)
    }
    
    convenience init?(inRoad: Road, outRoad: Road) {
        let inMask = inRoad.mask
        let outMask = outRoad.mask
        guard inMask.subMask & outMask.subMask == 0, !(inMask.a == outMask.b && inMask.b == outMask.a) else {
            return nil
        }
        
        let newBMtx = inRoad.movement.intersect(map: outRoad.movement)

        let n = inRoad.path.count + outRoad.path.count - 1

        let length = inRoad.length &+ outRoad.length

        var path = [Int](repeating: 0, count: n)
        
        for i in 0..<inRoad.path.count {
            path[i] = inRoad.path[i]
        }
        var j = inRoad.path.count
        for i in 1..<outRoad.path.count {
            path[j] = outRoad.path[i]
            j &+= 1
        }

        let visited = UInt64(mask: path)
        
        let factor = newBMtx.connectivityFactor(start: outMask.b, visited: visited)
        let size = newBMtx.array.count
        let validFactor = size - n
        let isNotHorde = factor == validFactor

        guard isNotHorde else { return nil }

        self.init(length: length, path: path, movement: newBMtx)
    }
    
}

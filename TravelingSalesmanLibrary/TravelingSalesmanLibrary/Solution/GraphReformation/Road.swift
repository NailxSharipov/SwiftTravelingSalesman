//
//  Road.swift
//  TravelingSalesmanLibrary
//
//  Created by Nail Sharipov on 17.04.2021.
//

public struct RoadMask: Hashable {
    
    let a: Int
    let b: Int
    let bitMask: UInt64
    
    @inline(__always)
    init(path: [Int]) {
        let n = path.count
        if n > 2 {
            var m: UInt64 = 0
            for i in 1..<n - 1 {
                let j = path[i]
                m = m | (1 << j)
            }
            self.bitMask = m
        } else {
            self.bitMask = 0
        }
        self.a = path[0]
        self.b = path[n - 1]
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(bitMask)
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
        Int(path[0])
    }
    
    @inline(__always)
    public var b: Int {
        Int(path[path.count - 1])
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
        let aMask = inRoad.mask
        let bMask = outRoad.mask
        guard aMask.bitMask & bMask.bitMask == 0, !(aMask.a == bMask.b && aMask.b == bMask.a)  else {
            return nil
        }
        
//        debugPrint("inRoad:")
//        debugPrint(inRoad.movement)
//
//        debugPrint("outRoad:")
//        debugPrint(outRoad.movement)
        
        let set = inRoad.movement.intersect(map: outRoad.movement)
        
//        debugPrint("result:")
//        debugPrint(set)
        
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
        
        let size = set.array.count
        
        let c = set[bMask.b].firstBitNotEmpty(size: size)
        guard c != -1 else { return nil }
        
        let visited = UInt64(mask: path)
        let mask = set[c]
        
        let isNotHorde = set.testConnectivity(mask: mask, visited: visited, count: size - n + 1)

        guard isNotHorde else { return nil }

        self.init(length: length, path: path, movement: set)
    }
    
}

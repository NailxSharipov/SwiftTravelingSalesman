//
//  ReusableRoad.swift
//  TravelingSalesmanLibrary
//
//  Created by Nail Sharipov on 04.05.2021.
//

struct ReusableRoad {

    let id: Int
    var path: UnsafeArray<Int>
    var length: Int
    var mask: RoadMask
    var movement: BitMatrix
    
    @inline(__always)
    var a: Int {
        mask.a
    }
    
    @inline(__always)
    var b: Int {
        mask.b
    }
    
    init(id: Int, count: Int) {
        self.id = id
        length = 0
        path = UnsafeArray<Int>(capacity: count)
        movement = BitMatrix(size: count)
        mask = RoadMask()
    }
    
    @inline(__always)
    mutating func prepare() {
        path.removeAll()
    }
    
    func dealocate() {
        path.dealocate()
        movement.deallocate()
    }
    
    @inline(__always)
    mutating func copyFrom(_ source: ReusableRoad) {
        length = source.length
        mask = source.mask
        movement.copyFrom(matrix: source.movement)
        path.replace(source.path.buffer, count: source.path.count)
    }
}

extension ReusableRoad: CustomStringConvertible {
    
    var description: String {
        return path.description
    }
}

extension ReusableRoad: CustomDebugStringConvertible {
    var debugDescription: String {
        self.description
    }
}

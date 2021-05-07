//
//  RoadMark.swift
//  TravelingSalesmanLibrary
//
//  Created by Nail Sharipov on 07.05.2021.
//

struct RoadMark {

    let id: Int
    let a: Int
    let b: Int
    let subMask: UInt64
    
    init(road: ReusableRoad) {
        self.id = road.id
        self.a = road.a
        self.b = road.b
        self.subMask = road.mask.subMask
    }
}

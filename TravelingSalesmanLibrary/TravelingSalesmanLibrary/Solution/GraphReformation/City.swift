//
//  City.swift
//  TravelingSalesmanLibrary
//
//  Created by Nail Sharipov on 17.04.2021.
//

public final class City {

    public let index: Int
    public internal (set) var outRoads: [Road]
    public internal (set) var inRoads: [Road]
    var isOutDirty = false
    var isInDirty = false
    public var isRemoved = false
    
    init(index: Int, outRoads: [Road], inRoads: [Road]) {
        self.index = index
        self.outRoads = outRoads
        self.inRoads = inRoads
    }
}

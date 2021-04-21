//
//  City.swift
//  TravelingSalesmanLibrary
//
//  Created by Nail Sharipov on 17.04.2021.
//

public final class City {
    
    public let index: Int
    public let roads = [Road]()
    var isRemoved: Bool = false
    let neighbours: FixSizeSet
    
    init(index: Int, size: Int) {
        self.index = index
        self.neighbours = FixSizeSet(size: size)
    }
}

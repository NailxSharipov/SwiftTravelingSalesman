//
//  Edge.swift
//  TravelingSalesmanLibrary
//
//  Created by Nail Sharipov on 15.04.2021.
//

public struct Edge {
    public let a: Int
    public let b: Int
    public var id: Int {
        a * 1000 + b
    }
}


extension Edge: CustomStringConvertible {
    public var description: String {
        "\(a)-\(b)"
    }
}

//
//  Solution.swift
//  TravelingSalesman
//
//  Created by Nail Sharipov on 07.03.2021.
//

import CoreGraphics

protocol Solution {
    func minPath(cities: [CGPoint]) -> [Int]
}

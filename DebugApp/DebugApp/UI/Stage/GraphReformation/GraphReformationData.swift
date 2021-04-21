//
//  GraphReformationData.swift
//  DebugApp
//
//  Created by Nail Sharipov on 17.04.2021.
//

import CoreGraphics

struct GraphReformationData {

    struct Data {
        let points: [CGPoint]
        
        init(_ points: [CGPoint]) {
            self.points = points
        }
    }

    static let data: [Data] = [
        Data([
            CGPoint(x: -15, y:  15),
            CGPoint(x:  15, y:  15),
            CGPoint(x:  15, y: -15),
            CGPoint(x: -15, y: -15)
        ]),
        Data([
            CGPoint(x:  -5, y:  15),
            CGPoint(x:   5, y:  15),
            CGPoint(x:  15, y:   5),
            CGPoint(x:  15, y:  -5),
            CGPoint(x:   5, y: -15),
            CGPoint(x:  -5, y: -15),
            CGPoint(x: -15, y:  -5),
            CGPoint(x: -15, y:   5)
        ]),
        Data([
            CGPoint(x: -25, y:   0),
            CGPoint(x: -15, y: -15),
            CGPoint(x: -10, y:  15),
            CGPoint(x: -10, y:  -5),
            
            CGPoint(x:   0, y:   5),
            CGPoint(x:  10, y:   5),
            CGPoint(x:  15, y: -15),
            CGPoint(x:  20, y:  15),
            CGPoint(x:  30, y:   0)
        ])
    ]
}

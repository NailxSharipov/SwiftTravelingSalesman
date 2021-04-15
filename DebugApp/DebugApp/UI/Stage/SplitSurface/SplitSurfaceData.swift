//
//  SplitSurfaceData.swift
//  DebugApp
//
//  Created by Nail Sharipov on 14.04.2021.
//

import CoreGraphics

struct SplitSurfaceData {

    static let data: [[CGPoint]] = [
        [
            CGPoint(x:   0, y:  10),
            CGPoint(x:  15, y:  -5),
            CGPoint(x:  10, y: -10),
            CGPoint(x: -10, y: -10),
            CGPoint(x: -10, y:   0)
        ],
        [
            CGPoint(x: -10, y:  10),
            CGPoint(x: -15, y:   5),
            CGPoint(x:   0, y:   5),
            CGPoint(x:   5, y:   0),
            CGPoint(x:  10, y: -15),
            CGPoint(x:  10, y:  10)
        ],
        [
            CGPoint(x: -5.0, y: 10.0),
            CGPoint(x: 5.0, y: 10.0),
            CGPoint(x: 5.0, y: 0.0),
            CGPoint(x: 20.0, y: -10.0),
            CGPoint(x: 5.0, y: 10.0),
            CGPoint(x: 0.0, y: -20.0),
            CGPoint(x: 10.0, y: 20.0)
        ]
    ]
}

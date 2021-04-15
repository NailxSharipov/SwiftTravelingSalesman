//
//  BruteForceData.swift
//  DebugApp
//
//  Created by Nail Sharipov on 14.04.2021.
//

import CoreGraphics

struct BruteForceData {

    static let data: [[CGPoint]] = [
        [// 1
            CGPoint(x: -10, y:  20),
            CGPoint(x:  10, y:  20),
            CGPoint(x:  10, y: -20),
            CGPoint(x: -10, y: -20),
            
            CGPoint(x: 01, y:  0)
        ],
        [// 2
            CGPoint(x: -10, y:  20),
            CGPoint(x:  10, y:  20),
            CGPoint(x:  10, y: -20),
            CGPoint(x: -10, y: -20),
            
            CGPoint(x:   5, y:  0)
        ],
        [// 3
            CGPoint(x: -10, y:  20),
            CGPoint(x:  10, y:  20),
            CGPoint(x:  10, y: -20),
            CGPoint(x: -10, y: -20),
            
            CGPoint(x:   5, y:  -5),
            CGPoint(x:   5, y:   5)
        ]
    ]
}

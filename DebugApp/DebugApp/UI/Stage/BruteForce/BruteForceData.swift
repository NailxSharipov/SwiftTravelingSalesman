//
//  BruteForceData.swift
//  DebugApp
//
//  Created by Nail Sharipov on 14.04.2021.
//

import CoreGraphics

struct BruteForceData {

    static let data: [[CGPoint]] = [
        Self.circles(n: 8, radiuses: [10]),
        [// 1
            CGPoint(x: -10, y:  20),
            CGPoint(x:  10, y:  20),
            CGPoint(x:  10, y: -20),
            CGPoint(x: -10, y: -20),
            
            CGPoint(x: 5, y:  0)
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
        ],
        Self.circles(n: 3, radiuses: [5, 10]),
        Self.circles(n: 3, radiuses: [5, 10, 20]),
        {
            var points = Self.circles(n: 20, radiuses: [25])
            points[18] = CGPoint(x: -15, y: -5)
            return points
        }(),
        Self.circles(n: 20, radiuses: [25]),
        Self.circles(n: 40, radiuses: [25]),
        Self.circles(n: 4, radiuses: [5, 10, 20])
    ]
    
    
    private static func circles(n: Int, radiuses: [CGFloat]) -> [CGPoint] {
        var points = [CGPoint]()
        points.reserveCapacity(n * radiuses.count)

        let dA = 2 * CGFloat.pi / CGFloat(n)

        for radius in radiuses {
            var a: CGFloat = 0
            for _ in 0..<n {
                let x: CGFloat = radius * sin(a)
                let y: CGFloat = radius * cos(a)
                points.append(CGPoint(x: x, y: y))
                a += dA
            }
        }

        return points
    }
}

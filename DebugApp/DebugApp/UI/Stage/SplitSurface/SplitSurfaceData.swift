//
//  SplitSurfaceData.swift
//  DebugApp
//
//  Created by Nail Sharipov on 14.04.2021.
//

import CoreGraphics

struct SplitSurfaceData {

    struct Data {
        let points: [CGPoint]
        let path: [Int]
        
        init(_ points: [CGPoint], path: [Int] = []) {
            self.points = points
            self.path = path
        }
    }

    static let data: [Data] = [
        Data([
            CGPoint(x: -15, y:  10),
            CGPoint(x:  -5, y:  -5),
            CGPoint(x:   5, y:   5),
            CGPoint(x:  15, y: -10)
        ]),
        Data(Self.circles(n: 8, radiuses: [10])),
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
        ]),
        Data([
            CGPoint(x: -15, y:  15),
            CGPoint(x:  15, y:  15),
            CGPoint(x:  15, y: -15),
            CGPoint(x: -15, y: -15),
            
            CGPoint(x:  -5, y:   5),
            CGPoint(x:   5, y:   5),
            CGPoint(x:   5, y:  -5),
            CGPoint(x:  -5, y:  -5)
        ]),
        Data([
            CGPoint(x: -25, y:  15),
            CGPoint(x:  25, y:  15),
            CGPoint(x:  25, y: -15),
            CGPoint(x: -25, y: -15),
            
            CGPoint(x:  -5, y:   5),
            CGPoint(x:   5, y:   5)
        ]),
        Data([
            CGPoint(x: -15, y:  15),
            CGPoint(x:  15, y:  15),
            CGPoint(x:  15, y: -15),
            CGPoint(x: -15, y: -15),
            
            CGPoint(x:   0, y:  10),
            CGPoint(x:  10, y:  0),
            CGPoint(x:   0, y: -10),
            CGPoint(x: -10, y:  0),
            
            CGPoint(x:   0, y:   0)
        ]),
        Data([
            CGPoint(x: -15, y:  15),
            CGPoint(x:  15, y:  15),
            CGPoint(x:  15, y: -15),
            CGPoint(x: -15, y: -15),

            
            CGPoint(x:   0, y:   0)
        ]),
        Data([
            CGPoint(x:   0, y:   6),
            CGPoint(x:   6, y:  -2),
            CGPoint(x:  -6, y:  -2),
            
            CGPoint(x:   0, y:  10),
            CGPoint(x:  10, y:  -4),
            CGPoint(x: -10, y:  -4)
        ]),
        Data(Self.circles(n: 3, radiuses: [5, 10])),
        Data(Self.circles(n: 3, radiuses: [5, 10, 20]))
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

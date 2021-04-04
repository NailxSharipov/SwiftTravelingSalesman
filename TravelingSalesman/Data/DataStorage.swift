//
//  DataStorage.swift
//  TravelingSalesman
//
//  Created by Nail Sharipov on 06.03.2021.
//

import CoreGraphics

struct DataStorage {

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
        ],
        [
            CGPoint(x: -10, y:  15),
            CGPoint(x:  10, y:  15),
            CGPoint(x: -10, y: -15),
            CGPoint(x:  10, y: -15)
        ],
        [
            CGPoint(x: -10, y:  15),
            CGPoint(x:  0, y:  9.15),
            CGPoint(x:  10, y:  15),
            CGPoint(x:  10, y: -15),
            CGPoint(x: -10, y: -15),
            CGPoint(x:  -5, y:   0)
        ],
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
        ],
        [// 4
            CGPoint(x: -10, y:  20),
            CGPoint(x:  10, y:  20),
            CGPoint(x:  10, y: -20),
            CGPoint(x: -10, y: -20),
            
            CGPoint(x:   5, y:  -5),
            CGPoint(x:   5, y:   0),
            CGPoint(x:   5, y:   5)
        ],
        [
            CGPoint(x: -10, y:  20),
            CGPoint(x:  10, y:  20),
            CGPoint(x:  10, y: -20),
            CGPoint(x: -10, y: -20),
            
            CGPoint(x:   5, y:  -5),
            CGPoint(x:   0, y:   0),
            CGPoint(x:   5, y:   5)
        ],
        [
            CGPoint(x: -10, y:  20),
            CGPoint(x:  10, y:  20),
            CGPoint(x:  10, y: -20),
            CGPoint(x: -10, y: -20),
            
            CGPoint(x:   5, y:  -5),
            CGPoint(x:  -2, y:   2),
            CGPoint(x:   5, y:   5)
        ],
        [ // sand clock
            CGPoint(x: -10, y:  20),
            CGPoint(x:  10, y:  20),
            
            CGPoint(x:   5, y:   5),
            CGPoint(x:   5, y:  -5),
            
            CGPoint(x:  10, y: -20),
            CGPoint(x: -10, y: -20),
            
            CGPoint(x:  -5, y:   0)
        ],
        [ // sand clock
            CGPoint(x: -10, y:  20),
            CGPoint(x:  10, y:  20),
            
            CGPoint(x:  10, y:   5),
            CGPoint(x:   5, y:   5),
            CGPoint(x:   5, y:  -5),
            
            CGPoint(x:  10, y: -20),
            CGPoint(x: -10, y: -20)
        ],
        [ // sand clock
            CGPoint(x: -10, y:  20),
            CGPoint(x:  10, y:  20),
            
            CGPoint(x:   5, y:   5),
            CGPoint(x:   0, y:   0),
            CGPoint(x:   5, y:  -5),
            
            CGPoint(x:  10, y: -20),
            CGPoint(x: -10, y: -20)
        ],
        [// 7
            CGPoint(x: -10, y:  20),
            CGPoint(x:  10, y:  20),
            CGPoint(x:  10, y: -20),
            CGPoint(x: -10, y: -20),
            
            CGPoint(x:   5, y:  -5),
            CGPoint(x:  20, y:   0),
            CGPoint(x:   5, y:   5)
        ],
        [// 8
            CGPoint(x: -10, y: -20),
            CGPoint(x: -10, y:  20),
            CGPoint(x:  10, y:  20),
            
            CGPoint(x:   5, y:   5),
            CGPoint(x:  20, y:   0),
            CGPoint(x:   5, y:  -5),
            
            CGPoint(x:  10, y: -20)
        ],
        [// 9
            CGPoint(x: -10, y:  10),
            CGPoint(x:  0,  y:  10),
            CGPoint(x:  10, y:  10),
            
            CGPoint(x: -10, y:   0),
            CGPoint(x:   0, y:   0),
            CGPoint(x:  10, y:   0),

            CGPoint(x: -10, y: -10),
            CGPoint(x:   0, y: -10),
            CGPoint(x:  10, y: -10)
        ],
        [
            CGPoint(x: -15, y:  15),
            CGPoint(x:  -5, y:  15),
            CGPoint(x:   5, y:  15),
            CGPoint(x:  15, y:  15),
            
            CGPoint(x:  15, y:   5),
            CGPoint(x:  15, y:  -5),
            
            CGPoint(x:  15, y: -15),
            CGPoint(x:   5, y: -15),
            CGPoint(x:  -5, y: -15),
            CGPoint(x: -15, y: -15),
            
            CGPoint(x:  -15, y:  -5),
            CGPoint(x:  -15, y:   5)
        ],
        [
            CGPoint(x: -20, y:  20),
            CGPoint(x: -10, y:  20),
            CGPoint(x:   0, y:  20),
            CGPoint(x:  10, y:  20),
            CGPoint(x:  20, y:  20),
            
            CGPoint(x:  20, y:  10),
            CGPoint(x:  20, y:   0),
            CGPoint(x:  20, y: -10),
            
            CGPoint(x:  20, y: -20),
            CGPoint(x:  10, y: -20),
            CGPoint(x:   0, y: -20),
            CGPoint(x: -10, y: -20),
            CGPoint(x: -20, y: -20),
            
            CGPoint(x: -20, y: -10),
            CGPoint(x: -20, y:   0),
            CGPoint(x: -20, y:  10)
        ],
        Self.circle(n: 8, radius: 20),
        Self.circle(n: 10, radius: 20),
        Self.circle(n: 16, radius: 20),
        Self.circle(n: 20, radius: 20),
        Self.circle(n: 24, radius: 20),
        Self.circle(n: 32, radius: 20),
        Self.circle(n: 50, radius: 20)
    ]
    
    
    private static func circle(n: Int, radius: CGFloat) -> [CGPoint] {
        var points = [CGPoint](repeating: .zero, count: n)

        let dA = 2 * CGFloat.pi / CGFloat(n)
        var a: CGFloat = 0

        for i in 0..<n {
            let x: CGFloat = radius * cos(a)
            let y: CGFloat = radius * sin(a)
            points[i] = CGPoint(x: x, y: y)
            a += dA
        }

        return points
    }
}




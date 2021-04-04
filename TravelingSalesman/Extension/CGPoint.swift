//
//  CGPoint.swift
//  TravelingSalesman
//
//  Created by Nail Sharipov on 06.03.2021.
//

import CoreGraphics

extension CGPoint {
    
    init(radius: CGFloat, angle: CGFloat) {
        let x = radius * cos(angle)
        let y = radius * sin(angle)
        self.init(x: x, y: y)
    }
    
    var length: CGFloat {
        return (x * x + y * y).squareRoot()
    }
    
    var magnitude: CGFloat {
        return x * x + y * y
    }
    
    var normalize: CGPoint {
        let l = self.length
        return CGPoint(x: x / l, y: y / l)
    }

}

func +(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func -(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func *(left: CGFloat, right: CGPoint) -> CGPoint {
    return CGPoint(x: left * right.x, y: left * right.y)
}

func /(left: CGPoint, right: CGFloat) -> CGPoint {
    return CGPoint(x: left.x / right, y: left.y / right)
}

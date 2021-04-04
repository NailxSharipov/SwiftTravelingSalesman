//
//  Area.swift
//  TravelingSalesman
//
//  Created by Nail Sharipov on 09.03.2021.
//

import Foundation


extension Array where Element == CGPoint {
    
    var area: CGFloat {
        guard var p1 = self.last else {
            return 0
        }
        
        var sum: CGFloat = 0
        
        for p2 in self {
            let x = p2.x - p1.x
            let y = p2.y + p1.y
            sum += x * y
            p1 = p2
        }

        return 0.5 * sum
    }
    
}

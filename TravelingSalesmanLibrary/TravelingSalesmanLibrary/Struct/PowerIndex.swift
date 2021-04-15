//
//  PowerIndex.swift
//  TravelingSalesmanLibrary
//
//  Created by Nail Sharipov on 15.04.2021.
//

struct PowerIndex {
    
    let array: [Float]
    
    init(matrix: AdMatrix) {
        let n = matrix.size

        var buffer = [Float](repeating: 0, count: n)
        for i in 0..<n {
            var a = 0
            for j in 0..<n {
                a += matrix[i, j]
            }
            buffer[i] = 0.01 * Float(a / 1000)
        }
        self.array = buffer
    }

}

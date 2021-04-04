//
//  StageData.swift
//  TravelingSalesman
//
//  Created by Nail Sharipov on 06.03.2021.
//

import SwiftUI

final class StageData: ObservableObject, Stage {

    private (set) var pageIndex: Int
    private let key = String(describing: StageData.self)
    private let data: [[CGPoint]]
    private var moveIndex: Int?
    private var startPosition: CGPoint = .zero
    
    @Published var points: [CGPoint] = []
    var smartPath: [CGPoint] {
        let matrix = AdMatrix(nodes: self.points, scale: 10000)
        let indices = SetBrutForceSolution.minPath(matrix: matrix)
        var result = [CGPoint]()
        result.reserveCapacity(indices.count)
        for i in indices {
            result.append(self.points[i])
        }
        return result
    }
    
    var bruteForcePath: [CGPoint]? {
        guard self.points.count < 8 else {
            return nil
        }
        let matrix = AdMatrix(nodes: self.points, scale: 10000)

        let indices = BruteForceSolution.minPath(matrix: matrix)
        var result = [CGPoint]()
        result.reserveCapacity(indices.count)
        for i in indices {
            result.append(self.points[i])
        }
        
        return result
    }
    
    var powerIndex: PowerIndex{
        let matrix = AdMatrix(nodes: self.points, scale: 10000)
        let powerIndex = PowerIndex(matrix: matrix)
        
        return powerIndex
    }
    
    init(data: [[CGPoint]]) {
        self.data = data
//        self.pageIndex = 0
        self.pageIndex = UserDefaults.standard.integer(forKey: key)
        
        self.points = self.data[self.pageIndex]
        debugPrint(self.pageIndex)
    }
    
    func onNext() {
        let n = self.data.count
        self.pageIndex = (self.pageIndex + 1) % n
        UserDefaults.standard.set(self.pageIndex, forKey: key)
        self.points = self.data[self.pageIndex]
        debugPrint(self.pageIndex)
    }
    
    func onPrev() {
        let n = self.data.count
        self.pageIndex = (self.pageIndex - 1 + n) % n
        UserDefaults.standard.set(pageIndex, forKey: self.key)
        self.points = self.data[self.pageIndex]
        debugPrint(self.pageIndex)
    }
    
    func onStart(start: CGPoint, radius: CGFloat) -> Bool {
        let ox = start.x
        let oy = start.y
        self.moveIndex = nil
        var min = radius * radius
        for i in 0..<self.points.count {
            let p = self.points[i]
            let dx = p.x - ox
            let dy = p.y - oy
            let rr = dx * dx + dy * dy
            if rr < min {
                min = rr
                self.moveIndex = i
                self.startPosition = p
            }
        }

        return self.moveIndex != nil
    }
    
    func onMove(delta: CGSize) {
        guard let index = self.moveIndex else {
            return
        }
        let dx = delta.width
        let dy = delta.height
        self.points[index] = CGPoint(x: self.startPosition.x - dx, y: self.startPosition.y - dy)
    }
    
    func onEnd(delta: CGSize) {
        self.onMove(delta: delta)
    }
}

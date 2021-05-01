//
//  BruteForceLogic.swift
//  DebugApp
//
//  Created by Nail Sharipov on 14.04.2021.
//

import SwiftUI
import TravelingSalesmanLibrary

final class BruteForceLogic: ObservableObject, Stage {
    private (set) var pageIndex: Int
    private let key = String(describing: BruteForceLogic.self)
    private let data: [[CGPoint]]
    private var moveIndex: Int?
    private var startPosition: CGPoint = .zero
    
    @Published var points: [CGPoint] = []
    var minPath: [CGPoint] {
        let matrix = AdMatrix(nodes: self.points)

        let indices = BruteForceCutSolution.minPath(matrix: matrix)
        var result = [CGPoint]()
        result.reserveCapacity(indices.count)
        for i in indices {
            result.append(self.points[i])
        }
        
        return result
    }

    
    init(data: [[CGPoint]]) {
        self.data = data
//        self.pageIndex = 0
        self.pageIndex = UserDefaults.standard.integer(forKey: key)
        
        self.points = self.data[self.pageIndex]
        (NSApplication.shared.delegate as? AppDelegate)?.title = "BruteForce (\(pageIndex))"
    }
    
    func onNext() {
        let n = self.data.count
        self.pageIndex = (self.pageIndex + 1) % n
        UserDefaults.standard.set(self.pageIndex, forKey: key)
        self.points = self.data[self.pageIndex]
        (NSApplication.shared.delegate as? AppDelegate)?.title = "BruteForce (\(pageIndex))"
    }
    
    func onPrev() {
        let n = self.data.count
        self.pageIndex = (self.pageIndex - 1 + n) % n
        UserDefaults.standard.set(pageIndex, forKey: self.key)
        self.points = self.data[self.pageIndex]
        (NSApplication.shared.delegate as? AppDelegate)?.title = "BruteForce (\(pageIndex))"
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

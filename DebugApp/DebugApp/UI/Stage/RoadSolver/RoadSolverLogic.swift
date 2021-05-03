//
//  RoadSolverLogic.swift
//  DebugApp
//
//  Created by Nail Sharipov on 25.04.2021.
//

import SwiftUI
import TravelingSalesmanLibrary

final class RoadSolverLogic: ObservableObject, Stage {

    private (set) var pageIndex: Int
    private let key = String(describing: RoadSolverLogic.self)
    private let data: [RoadSolverData.Data]
    private var moveIndex: Int?
    private var startPosition: CGPoint = .zero
    
    struct ViewModel {
        let dots: [DotView.Data]
        let steps: [EdgeView.Data]
    }
    
    @Published var points: [CGPoint] = []
    var viewModel: ViewModel {
        let edgeIndices = RoadSolution.minPath(matrix: AdMatrix(nodes: self.points))
        
        var dots = [DotView.Data]()
        dots.reserveCapacity(points.count)

        
        for i in 0..<points.count {
            dots.append(DotView.Data(index: i, point: points[i], name: "", color: .gray))
        }
        
        var steps = [EdgeView.Data]()

        if !edgeIndices.isEmpty {
            steps.reserveCapacity(edgeIndices.count)
            var a = points[edgeIndices[edgeIndices.count - 1]]
            for i in 0..<edgeIndices.count {
                let b = points[edgeIndices[i]]
                steps.append(EdgeView.Data(index: i, points: [a, b]))
                a = b
            }
        }

        return ViewModel(dots: dots, steps: steps)
    }
    
    init(data: [RoadSolverData.Data]) {
        self.data = data
//        self.pageIndex = 0
        self.pageIndex = UserDefaults.standard.integer(forKey: key)
        
        self.points = self.data[self.pageIndex].points
        (NSApplication.shared.delegate as? AppDelegate)?.title = "RoadSolver (\(pageIndex))"
    }
    
    func onNext() {
        let n = self.data.count
        self.pageIndex = (self.pageIndex + 1) % n
        UserDefaults.standard.set(self.pageIndex, forKey: key)
        self.points = self.data[self.pageIndex].points
        (NSApplication.shared.delegate as? AppDelegate)?.title = "RoadSolver (\(pageIndex))"
    }
    
    func onPrev() {
        let n = self.data.count
        self.pageIndex = (self.pageIndex - 1 + n) % n
        UserDefaults.standard.set(pageIndex, forKey: self.key)
        self.points = self.data[self.pageIndex].points
        (NSApplication.shared.delegate as? AppDelegate)?.title = "RoadSolver (\(pageIndex))"
    }
    
    func onStart(start: CGPoint, radius: CGFloat) -> Bool {
        guard let index = self.findIndex(pos: start, radius: radius) else {
            self.moveIndex = nil
            return false
        }
        self.moveIndex = index
        self.startPosition = self.points[index]

        return true
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
    
    private func findIndex(pos: CGPoint, radius: CGFloat) -> Int? {
        let ox = pos.x
        let oy = pos.y
        var min = radius * radius
        for i in 0..<self.points.count {
            let p = self.points[i]
            let dx = p.x - ox
            let dy = p.y - oy
            let rr = dx * dx + dy * dy
            if rr < min {
                min = rr
                return i
            }
        }
        
        return nil
    }
}

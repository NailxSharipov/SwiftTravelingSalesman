//
//  SplitSurfaceLogic.swift
//  DebugApp
//
//  Created by Nail Sharipov on 14.04.2021.
//

import SwiftUI
import TravelingSalesmanLibrary

final class SplitSurfaceLogic: ObservableObject, Stage {

    private (set) var pageIndex: Int
    private let key = String(describing: SplitSurfaceLogic.self)
    private let data: [SplitSurfaceData.Data]
    private var moveIndex: Int?
    private var startPosition: CGPoint = .zero
    
    struct ViewModel {
        let dots: [DotView.Data]
        let hordes: [EdgeView.Data]
        let steps: [EdgeView.Data]
    }
    
    @Published var points: [CGPoint] = []
    var viewModel: ViewModel {
        let matrix = AdMatrix(nodes: self.points)
        let info = SurfaceSplitSolution.info(matrix: matrix)
        
        var dots = [DotView.Data]()
        dots.reserveCapacity(info.dots.count)
        for dot in info.dots {
            let point = points[dot.index]
            dots.append(DotView.Data(index: dot.index, point: point, name: dot.description, color: .gray))
        }
        
        var hordes = [EdgeView.Data]()
        hordes.reserveCapacity(info.hordes.count)
        var i = 0
        for edge in info.hordes {
            let a = points[edge.a]
            let b = points[edge.b]
            hordes.append(EdgeView.Data(index: i, points: [a, b]))
            i += 1
        }
        
        var steps = [EdgeView.Data]()
        steps.reserveCapacity(info.steps.count)
        i = 0
        for edge in info.steps {
            let a = points[edge.a]
            let b = points[edge.b]
            steps.append(EdgeView.Data(index: i, points: [a, b]))
            i += 1
        }

        return ViewModel(dots: dots, hordes: hordes, steps: steps)
    }
    
    init(data: [SplitSurfaceData.Data]) {
        self.data = data
//        self.pageIndex = 0
        self.pageIndex = UserDefaults.standard.integer(forKey: key)
        
        self.points = self.data[self.pageIndex].points
        (NSApplication.shared.delegate as? AppDelegate)?.title = "SplitSurface (\(pageIndex))"
    }
    
    func onNext() {
        let n = self.data.count
        self.pageIndex = (self.pageIndex + 1) % n
        UserDefaults.standard.set(self.pageIndex, forKey: key)
        self.points = self.data[self.pageIndex].points
        (NSApplication.shared.delegate as? AppDelegate)?.title = "SplitSurface (\(pageIndex))"
    }
    
    func onPrev() {
        let n = self.data.count
        self.pageIndex = (self.pageIndex - 1 + n) % n
        UserDefaults.standard.set(pageIndex, forKey: self.key)
        self.points = self.data[self.pageIndex].points
        (NSApplication.shared.delegate as? AppDelegate)?.title = "SplitSurface (\(pageIndex))"
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

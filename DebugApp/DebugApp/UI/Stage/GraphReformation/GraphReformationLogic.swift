//
//  GraphReformationLogic.swift
//  DebugApp
//
//  Created by Nail Sharipov on 17.04.2021.
//

import SwiftUI
import TravelingSalesmanLibrary

final class GraphReformationLogic: ObservableObject, Stage {

    private (set) var pageIndex: Int
    private let key = String(describing: GraphReformationLogic.self)
    private let data: [GraphReformationData.Data]
    private var moveIndex: Int?
    private var startPosition: CGPoint = .zero
    private var removed = [Int]()
    
    struct ViewModel {
        let dots: [DotView.Data]
        let bows: [BowView.Data]
    }
    
    @Published var points: [CGPoint] = []
    var viewModel: ViewModel {
        let matrix = AdMatrix(nodes: self.points)
        let info = GraphReformationSolution.info(matrix: matrix, reform: [])
        
        var dots = [DotView.Data]()
        dots.reserveCapacity(info.cities.count)
        var roads = [Road]()
        var set = Set<RoadPair>()
        for city in info.cities {
            let point = points[city.index]
            let color: Color
            if removed.contains(city.index) {
                color = Color(red: 1, green: 0.5, blue: 0.5, opacity: 0.7)
            } else {
                color = Color.gray
            }
            dots.append(DotView.Data(index: city.index, point: point, name: city.description, color: color))
            
            for road in city.roads {
                let pair = RoadPair(road: road)
                if !set.contains(pair) {
                    set.insert(pair)
                    roads.append(road)
                }
            }
        }

        var bows = [BowView.Data]()
        bows.reserveCapacity(roads.count)
        for (i, road) in roads.enumerated() {
            let ai = Int(road.path.first!)
            let bi = Int(road.path.last!)
            let a = points[ai]
            let b = points[bi]
            let l = matrix.scale(length: road.length)
            let isDirect: Bool
            let description: String?
            if road.path.count > 2 {
                isDirect = false
                description = road.path[1..<road.path.count - 1].map({ String($0) }).joined(separator: "-")
            } else {
                isDirect = true
                description = nil
            }

            bows.append(BowView.Data(index: i, start: a, end: b, length: l, isDirect: isDirect, description: description))
        }

        return ViewModel(dots: dots, bows: bows)
    }
    
    init(data: [GraphReformationData.Data]) {
        self.data = data
//        self.pageIndex = 0
        self.pageIndex = UserDefaults.standard.integer(forKey: key)
        
        self.points = self.data[self.pageIndex].points
        self.removed.removeAll()
        (NSApplication.shared.delegate as? AppDelegate)?.title = "GraphReformation (\(pageIndex))"
    }
    
    func onNext() {
        let n = self.data.count
        self.pageIndex = (self.pageIndex + 1) % n
        UserDefaults.standard.set(self.pageIndex, forKey: key)
        self.points = self.data[self.pageIndex].points
        self.removed.removeAll()
        (NSApplication.shared.delegate as? AppDelegate)?.title = "GraphReformation (\(pageIndex))"
    }
    
    func onPrev() {
        let n = self.data.count
        self.pageIndex = (self.pageIndex - 1 + n) % n
        UserDefaults.standard.set(pageIndex, forKey: self.key)
        self.points = self.data[self.pageIndex].points
        self.removed.removeAll()
        (NSApplication.shared.delegate as? AppDelegate)?.title = "GraphReformation (\(pageIndex))"
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
    
    func onEsk(location: CGPoint) {
        guard let index = self.findIndex(pos: location, radius: 1) else {
            return
        }

        if let j = removed.firstIndex(of: index) {
            removed.remove(at: j)
        } else {
            removed.append(index)
        }
        
        objectWillChange.send()
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

struct RoadPair: Hashable {
    
    let index: Int
    
    init(road: Road) {
        let a = road.path.first!
        let b = road.path.last!
        
        if a > b {
            index = (Int(a) << 8) + Int(b)
        } else {
            index = (Int(b) << 8) + Int(a)
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(index)
    }
    
    static func == (lhs: RoadPair, rhs: RoadPair) -> Bool {
        lhs.index == rhs.index
    }
}

//
//  Road.swift
//  TravelingSalesmanLibrary
//
//  Created by Nail Sharipov on 17.04.2021.
//

public final class Road {
    
    public let path: [Int8]
    public let length: Int
    public let roadGroupId: Int
    let code: [Int8]
    let hash: Int
    
    init(roadGroupId: Int = -1, length: Int, path: [Int8]) {
        self.roadGroupId = roadGroupId
        self.length = length
        self.path = path
        self.code = path.sorted()
        var hash = 0
        for p in path {
            hash += Int(p)
            hash = hash << 8
        }
        self.hash = hash
    }
    
}

extension Road: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        self.path.withUnsafeBytes { buffer in
            hasher.combine(bytes: buffer)
        }
    }
    
    public static func == (lhs: Road, rhs: Road) -> Bool {
        let lenA = lhs.path.count
        let lenB = rhs.path.count
        
        guard lenA == lenB && lhs.length == rhs.length else {
            return false
        }
        
        return lhs.path == rhs.path
    }
}

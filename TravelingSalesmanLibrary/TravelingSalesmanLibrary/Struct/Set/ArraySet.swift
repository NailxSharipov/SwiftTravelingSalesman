//
//  ArraySet.swift
//  TravelingSalesmanLibrary
//
//  Created by Nail Sharipov on 15.04.2021.
//

struct ArraySet {
    
    fileprivate let array: [Bool]

    init(set: [Int], size: Int) {
        var buffer = [Bool](repeating: false, count: size)
        for p in set {
            buffer[p] = true
        }
        self.array = buffer
    }
}

extension Array where Element == Int {
    
    @inline(__always)
    func isFromOneSide(set: ArraySet) -> Bool {
        guard self.count > 0 else { return true }
        let value = set.array[self[0]]
        
        for p in self {
            if value != set.array[p] {
                return false
            }
        }

        return true
    }
}

extension ArraySlice where Element == Int {
    
    @inline(__always)
    func isFromOneSide(set: ArraySet) -> Bool {
        guard self.count > 0 else { return true }
        let value = set.array[self[0]]
        
        for p in self {
            if value != set.array[p] {
                return false
            }
        }

        return true
    }
}

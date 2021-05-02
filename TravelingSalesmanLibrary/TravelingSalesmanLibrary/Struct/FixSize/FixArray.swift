//
//  FixArray.swift
//  TravelingSalesmanLibrary
//
//  Created by Nail Sharipov on 02.05.2021.
//

struct FixArray {
    
    private let buffer: UnsafeMutablePointer<Int>
    private (set) var count: Int
    
    @inline(__always)
    subscript(index: Int) -> Int {
        get {
            buffer[index]
        }
        set {
            buffer[index] = newValue
        }
    }

    var toArray: [Int] {
        var result = [Int](repeating: 0, count: count)
        for i in 0..<count {
            result[i] = buffer[i]
        }
        return result
    }
    
    @inline(__always)
    func fill(buffer: inout [Int]) {
        for i in 0..<count {
            buffer[i] = self.buffer[i]
        }
    }
    
    @inline(__always)
    mutating func append(_ value: Int) {
        buffer[count] = value
        count &+= 1
    }
    
    @inline(__always)
    mutating func removeLast() {
        count &-= 1
    }
    
    init(capacity: Int) {
        self.buffer = UnsafeMutablePointer<Int>.allocate(capacity: capacity)
        for i in 0..<capacity {
            buffer[i] = 0
        }
        self.count = 0
    }

    func dealocate() {
        self.buffer.deallocate()
    }

}

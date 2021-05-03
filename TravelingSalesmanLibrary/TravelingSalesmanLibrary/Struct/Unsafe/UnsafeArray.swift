//
//  UnsafeArray.swift
//  TravelingSalesmanLibrary
//
//  Created by Nail Sharipov on 02.05.2021.
//

struct UnsafeArray<Element: FixedWidthInteger> {
    
    private let buffer: UnsafeMutablePointer<Element>
    private (set) var count: Int
    
    @inline(__always)
    subscript(index: Int) -> Element {
        get {
            buffer[index]
        }
        set {
            buffer[index] = newValue
        }
    }

    var toArray: [Element] {
        var result = [Element](repeating: 0, count: count)
        var i = 0
        while i < count {
            result[i] = buffer[i]
            i &+= 1
        }
        return result
    }
    
    @inline(__always)
    func fill(buffer: inout [Element]) {
        var i = 0
        while i < count {
            buffer[i] = self.buffer[i]
            i &+= 1
        }
    }
    
    @inline(__always)
    mutating func append(_ value: Element) {
        buffer[count] = value
        count &+= 1
    }
    
    @inline(__always)
    mutating func removeLast() {
        count &-= 1
    }
    
    init(capacity: Int) {
        buffer = UnsafeMutablePointer<Element>.allocate(capacity: capacity)
        buffer.initialize(repeating: 0, count: capacity)
        count = 0
    }

    func dealocate() {
        buffer.deinitialize(count: count)
        buffer.deallocate()
    }

}

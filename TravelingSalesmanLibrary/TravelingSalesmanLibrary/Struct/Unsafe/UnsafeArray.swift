//
//  UnsafeArray.swift
//  TravelingSalesmanLibrary
//
//  Created by Nail Sharipov on 02.05.2021.
//

struct UnsafeArray<Element: FixedWidthInteger> {
    
    let buffer: UnsafeMutablePointer<Element>
    
    @inline(__always)
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
    
    var first: Element {
        buffer[0]
    }
    
    var last: Element {
        buffer[count - 1]
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
    mutating func replace(_ value: UnsafeMutablePointer<Element>, count: Int) {
        buffer.assign(from: value, count: count)
        self.count = count
    }
    
    @inline(__always)
    mutating func removeLast() {
        count &-= 1
    }
    
    @inline(__always)
    mutating func removeAll() {
        count = 0
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

extension UnsafeArray: CustomStringConvertible {
    
    var description: String {
        var result = String()
        result.append("\(buffer[0])")
        for i in 1..<count {
            result.append(", \(buffer[i])")
        }
        return result
    }
}

extension UnsafeArray: CustomDebugStringConvertible {
    var debugDescription: String {
        self.description
    }
}

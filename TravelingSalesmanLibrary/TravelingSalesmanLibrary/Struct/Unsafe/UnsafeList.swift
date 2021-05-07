//
//  UnsafeList.swift
//  TravelingSalesmanLibrary
//
//  Created by Nail Sharipov on 07.05.2021.
//

struct UnsafeList<Element> {
    
    private var buffer: UnsafeMutablePointer<Element>
    private (set) var count: Int
    private (set) var capacity: Int
    
    @inline(__always)
    subscript(index: Int) -> Element {
        get {
            buffer[index]
        }
        set {
            buffer[index] = newValue
        }
    }
    
    @inline(__always)
    var first: Element {
        buffer[0]
    }
    
    @inline(__always)
    var last: Element {
        buffer[count - 1]
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
        if count == capacity {
            let newCapacity = 2 * capacity
            let newBuffer = UnsafeMutablePointer<Element>.allocate(capacity: newCapacity)
            newBuffer.initialize(from: buffer, count: capacity)
            buffer.deallocate()
            capacity = newCapacity
            buffer = newBuffer
        }
        buffer[count] = value
        count &+= 1
    }
    
    @inline(__always)
    mutating func removeLast() -> Element {
        count &-= 1
        return buffer[count]
    }
    
    @inline(__always)
    mutating func removeAll() {
        count = 0
    }
    
    init(capacity: Int) {
        buffer = UnsafeMutablePointer<Element>.allocate(capacity: capacity)
//        buffer.initialize(repeating: 0, count: capacity)
        count = 0
        self.capacity = capacity
    }
    
    init(count: Int, template: Element) {
        buffer = UnsafeMutablePointer<Element>.allocate(capacity: count)
        buffer.initialize(repeating: template, count: count)
        self.count = count
        self.capacity = count
    }
    
    init(array: [Element]) {
        buffer = UnsafeMutablePointer<Element>.allocate(capacity: array.capacity)
        buffer.initialize(from: array, count: array.count)
        self.count = array.count
        self.capacity = array.capacity
    }

    func dealocate() {
        buffer.deallocate()
    }

}

extension UnsafeList: CustomStringConvertible {
    
    var description: String {
        var result = String()
        result.append("\(buffer[0])")
        for i in 1..<count {
            result.append(", \(buffer[i])")
        }
        return result
    }
}

extension UnsafeList: CustomDebugStringConvertible {
    var debugDescription: String {
        self.description
    }
}

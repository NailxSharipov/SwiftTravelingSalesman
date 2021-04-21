//
//  FixSizeSet.swift
//  TravelingSalesmanLibrary
//
//  Created by Nail Sharipov on 18.04.2021.
//

struct FixSizeSet {
    
    private struct Node {
        static let empty = Node(prev: -1, value: false, next: -1)
        fileprivate (set) var prev: Int
        fileprivate (set) var value: Bool
        fileprivate (set) var next: Int
        
        fileprivate init(prev: Int, value: Bool, next: Int) {
            self.prev = prev
            self.value = value
            self.next = next
        }
    }

    private (set) var count: Int
    private (set) var first: Int
    private (set) var last: Int
    private var nodes: [Node]
    
    private (set) var buffer: FixSizeArray
    
    @inline(__always)
    mutating func values() -> FixSizeArray {
        guard first != -1 else {
            buffer.count = 0
            return buffer
        }
        var index = first

        var i = 0
        while index != -1 {
            buffer[i] = index
            index = nodes[index].next
            i += 1
        }
        buffer.count = i
        return buffer
    }
    
    init(size: Int) {
        nodes = [Node](repeating: .empty, count: size)
        buffer = FixSizeArray(size: size)
        first = -1
        last = -1
        count = 0
    }

    @inline(__always)
    subscript(index: Int) -> Bool {
        get {
            nodes[index].value
        }
        set {
            if newValue {
                self.add(index: index)
            } else {
                self.remove(index: index)
            }
        }
    }

    @inline(__always)
    mutating func add(index: Int) {
        var node = nodes[index]
        guard !node.value else {
            return
        }
        node.value = true
        
        if last != -1 {
            var lastNode = nodes[last]
            lastNode.next = index
            nodes[last] = lastNode
        } else {
            first = index
        }
        
        node.prev = last
        last = index

        nodes[index] = node
        count += 1
    }

    @inline(__always)
    @discardableResult
    mutating func remove(index: Int) -> Bool {
        let node = nodes[index]
        guard node.value else {
            return false
        }
        nodes[index] = .empty
       
        if node.prev != -1 {
            nodes[node.prev].next = node.next
        } else {
            first = node.next
        }
        
        if node.next != -1 {
            nodes[node.next].prev = node.prev
        } else {
            last = node.prev
        }
        
        count -= 1
        return true
    }

    @inline(__always)
    mutating func removeAll() {
        first = -1
        last = -1
        count = 0
        for i in 0..<nodes.count {
            nodes[i] = .empty
        }
    }
}

extension FixSizeSet: CustomStringConvertible {
    
    var description: String {
        return buffer.description
    }
}

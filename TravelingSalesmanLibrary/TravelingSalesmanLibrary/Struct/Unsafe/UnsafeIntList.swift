//
//  UnsafeIntList.swift
//  TravelingSalesmanLibrary
//
//  Created by Nail Sharipov on 15.04.2021.
//
import CoreGraphics

struct UnsafeIntList {
    
    struct Node: Equatable {
        static let empty = Node(prev: -1, index: -1, next: -1)
        fileprivate (set) var prev: Int
        fileprivate (set) var index: Int
        fileprivate (set) var next: Int
        
        fileprivate init(prev: Int, index: Int, next: Int) {
            self.prev = prev
            self.index = index
            self.next = next
        }
        
        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.index == rhs.index
        }
    }

    private (set) var count: Int
    private (set) var first: Int
    private (set) var last: Int
    private var nodes: UnsafeMutablePointer<Node>
    
    init(count: Int) {
        nodes = UnsafeMutablePointer<Node>.allocate(capacity: count)
        nodes.initialize(repeating: Node.empty, count: count)
        first = 0
        last = count - 1

        var next = 1
        var prev = -1
        for i in 0..<count {
            nodes[i] = Node(prev: prev, index: i, next: next)
            prev = i
            next += 1
        }
        
        nodes[last].next = -1
        self.count = count
    }
    
    func dealocate() {
        nodes.deinitialize(count: count)
        nodes.deallocate()
    }

    @inline(__always)
    subscript(index: Int) -> Bool {
        get {
            nodes[index].index != -1
        }
        set {
            if newValue {
                self.add(index: index)
            } else {
                _ = self.remove(index: index)
            }
        }
    }

    @inline(__always)
    mutating func add(index: Int) {
        var node = nodes[index]
        node.index = index
        
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
    mutating func add(node: Node) {
        nodes[node.index] = node
        
        if node.prev != -1 {
            nodes[node.prev].next = node.index
        } else {
            first = node.index
        }
        
        if node.next != -1 {
            nodes[node.next].prev = node.index
        } else {
            last = node.index
        }
        count += 1
    }
    
    @inline(__always)
    mutating func remove(index: Int) -> Node {
        let node = nodes[index]
        assert(node.index == index)
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
        return node
    }
}

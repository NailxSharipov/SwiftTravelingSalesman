//
//  OpenLinkedList.swift
//  TravelingSalesmanLibrary
//
//  Created by Nail Sharipov on 15.04.2021.
//
import CoreGraphics

struct OpenLinkedList {
    
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
    
    @inline(__always)
    var path: [Int] {
        guard first != -1 else { return [] }
        var array = [Int]()
        array.reserveCapacity(nodes.count)
        var node = nodes[first]
        while node.next != -1 {
            array.append(node.index)
            node = nodes[node.next]
        }
        array.append(node.index)
        
        return array
    }

    private (set) var count: Int
    private (set) var first: Int
    private (set) var last: Int
    private var nodes: [Node]
    
    init(count: Int, isEmpty: Bool) {
        nodes = [Node](repeating: .empty, count: count)
        guard !isEmpty else {
            first = -1
            last = -1
            self.count = 0
            return
        }
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

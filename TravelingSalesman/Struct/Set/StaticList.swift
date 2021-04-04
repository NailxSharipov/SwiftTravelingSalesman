//
//  ArrayList.swift
//  TravelingSalesman
//
//  Created by Nail Sharipov on 30.03.2021.
//

struct StaticList {
    
    struct Node {
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
    private (set) var nodes: [Node]
    
    @inline(__always)
    var values: [Int] {
        guard first != -1 else { return [] }
        var array = [Int]()
        array.reserveCapacity(count)

        var index = first

        while index != -1 {
            array.append(index)
            index = nodes[index].next
        }
        return array
    }
    
    init(size: Int, isOptimal: Bool) {
        nodes = [Node](repeating: .empty, count: size)
        if isOptimal {
            first = 0
            last = size - 1
            
            for i in 0..<size {
                nodes[i] = Node(prev: i - 1, value: true, next: i + 1)
            }
            nodes[size - 1].next = -1
            count = size
        } else {
            first = -1
            last = -1
            count = 0
        }
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
    func next(index: Int) -> Int {
        nodes[index].next
    }
    
    @inline(__always)
    func prev(index: Int) -> Int {
        nodes[index].prev
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
    mutating func remove(index: Int) {
        let node = nodes[index]
        guard node.value else {
            return
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
    }
    
    @inline(__always)
    mutating func subtract(a: Int, set: UnoptimalEdgeMatrix) {
        guard first >= 0 else { return }

        var index = first

        while index != -1 {
            let next = nodes[index].next
            if set[a, index] { // not optimal
                self.remove(index: index)
            }

            index = next
        }
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

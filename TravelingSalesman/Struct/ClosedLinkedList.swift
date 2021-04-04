//
//  ClosedLinkedList.swift
//  TravelingSalesman
//
//  Created by Nail Sharipov on 12.03.2021.
//

struct ClosedLinkedList {
    
    struct Node: Equatable {
        fileprivate (set) var prev: Int
        let index: Int
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
    var count: Int {
        nodes.count
    }
    
    @inline(__always)
    var first: Node {
        self.nodes[0]
    }
    
    var array: [Int] {
        let n = nodes.count
        var buffer = [Int](repeating: 0, count: n)
        var next = nodes[0]
        for i in 0..<n {
            buffer[i] = next.index
            next = nodes[next.next]
        }

        return buffer
    }
    
    private var nodes: [Node]
    
    init(array: [Int]) {
        let count = array.count
        nodes = [Node](repeating: Node(prev: 0, index: 0, next: 0), count: count)
        var prev = array[count - 2]
        var index = array[count - 1]
        for next in array {
            nodes[index] = Node(prev: prev, index: index, next: next)
            prev = index
            index = next
        }
    }
    
    @inline(__always)
    subscript(index: Int) -> Node {
        nodes[index]
    }
    
    func path(start: Int, end: Int) -> [Int] {
        var array = [Int]()
        array.reserveCapacity(count)
        
        var next = nodes[start]
        repeat {
            array.append(next.index)
            next = nodes[next.next]
        } while next.prev != end
        
        return array
    }
    
    func path(start: Int) -> [Int] {
        let n = nodes.count
        var buffer = [Int](repeating: 0, count: n)
        
        var next = nodes[start]
        for i in 0..<n {
            buffer[i] = next.index
            next = nodes[next.next]
        }

        return buffer
    }

    @inline(__always)
    func next(_ node: Node) -> Node {
        nodes[node.next]
    }
    
    @inline(__always)
    func next(_ node: Node, length: Int) -> Node {
        var i = 0
        var node = node
        repeat {
            node = nodes[node.next]
            i += 1
        } while i < length
        
        return node
    }
    

    @inline(__always)
    func prev(_ node: Node) -> Node {
        nodes[node.prev]
    }
    
    @inline(__always)
    mutating func remove(node: Node) {
        var prev = nodes[node.prev]
        var next = nodes[node.next]
        
        prev.next = next.index
        next.prev = prev.index
        
        nodes[node.prev] = prev
        nodes[node.next] = next
    }
    
    @inline(__always)
    mutating func remove(index: Int) {
        self.remove(node: nodes[index])
    }
    
    @inline(__always)
    mutating func insert(node: Node, before: Node) {
        var newNode = node
        var before = nodes[before.index]
        var oldNext = nodes[before.next]
        
        before.next = node.index
        oldNext.prev = node.index

        newNode.prev = before.index
        newNode.next = oldNext.index

        nodes[before.index] = before
        nodes[oldNext.index] = oldNext
        
        nodes[newNode.index] = newNode
    }
    
    @inline(__always)
    mutating func turnOver(start a: Node, end b: Node) {
        let end = a.prev
        let start = b.next
        
        nodes[end].next = b.index
        nodes[start].prev = a.index

        var next = nodes[a.index]

        while next.index != start {
            let nextNext = nodes[next.next]
            
            next.next = next.prev
            next.prev = nextNext.index
            nodes[next.index] = next
            
            next = nextNext
        }
        
        nodes[a.index].next = start
        nodes[b.index].prev = end
    }
    
    @inline(__always)
    mutating func reverse(start: Node, end: Node) {
        var a = nodes[start.index]
        while a.index != end.index {
            let prev = a.prev
            a.prev = a.next
            a.next = prev
            nodes[a.index] = a
            
            a = nodes[a.prev]
        }
    }
    
    @inline(__always)
    mutating func connect(first: Node, next: Node) {
        self.connect(first: first.index, next: next.index)
    }
    
    @inline(__always)
    mutating func connect(first: Int, next: Int) {
        var a = nodes[first]
        var b = nodes[next]
        a.next = b.index
        b.prev = a.index
        
        nodes[a.index] = a
        nodes[b.index] = b
    }
    
    @inline(__always)
    mutating func move(index: Int, before: Int) {

        // remove
        var b1 = nodes[index]
        var b0 = nodes[b1.prev]
        var b2 = nodes[b1.next]
        
        b0.next = b2.index
        b2.prev = b0.index

        nodes[b0.index] = b0
        nodes[b2.index] = b2
        
        // insert
        
        var a = nodes[before]
        var c = nodes[a.next]
        
        a.next = b1.index
        c.prev = b1.index
        
        b1.next = c.index
        b1.prev = a.index

        nodes[a.index] = a
        nodes[b1.index] = b1
        nodes[c.index] = c
    }
    
    @inline(__always)
    mutating func move(index: Int, after: Int) {

        // remove
        var b1 = nodes[index]
        var b0 = nodes[b1.prev]
        var b2 = nodes[b1.next]
        
        b0.next = b2.index
        b2.prev = b0.index

        nodes[b0.index] = b0
        nodes[b2.index] = b2
        
        // insert
        
        var a = nodes[after]
        var c = nodes[a.prev]
        
        a.prev = b1.index
        c.next = b1.index
        
        b1.prev = c.index
        b1.next = a.index

        nodes[a.index] = a
        nodes[b1.index] = b1
        nodes[c.index] = c
    }
    
    @inline(__always)
    mutating func move(index: Int, after: Int, matrix: AdMatrix) -> Int {

        var difference = 0
        
        // remove
        var b1 = nodes[index]
        var b0 = nodes[b1.prev]
        var b2 = nodes[b1.next]
        
        difference -= matrix[b0.index, b1.index]
        difference -= matrix[b1.index, b2.index]
        difference += matrix[b0.index, b2.index]
        
        b0.next = b2.index
        b2.prev = b0.index

        nodes[b0.index] = b0
        nodes[b2.index] = b2
        
        // insert
        
        var a = nodes[after]
        var c = nodes[a.prev]
        
        a.prev = b1.index
        c.next = b1.index
        
        b1.prev = c.index
        b1.next = a.index

        nodes[a.index] = a
        nodes[b1.index] = b1
        nodes[c.index] = c

        difference -= matrix[a.index, c.index]
        difference += matrix[a.index, b1.index]
        difference += matrix[c.index, b1.index]
        
        return difference
    }

    
}

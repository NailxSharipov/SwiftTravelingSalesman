//
//  GraphSolution.swift
//  TravelingSalesman
//
//  Created by Nail Sharipov on 10.03.2021.
//

import CoreGraphics

struct RoundSolution: Solution {

    func minPath(matrix: AdjacencyMatrix) -> [Int] {
        let n = matrix.size
        
        guard n > 3 else {
            return Array(0..<n)
        }
        
        var list = LinkedList(array: Array(0..<n))

        self.removeCrosses(list: &list, matrix: matrix)
        self.joinNearest(list: &list, matrix: matrix)
        
        return list.array
    }
    
    func removeCrosses(list: inout LinkedList, matrix: AdjacencyMatrix) {
        let n = matrix.size
        var counter = 0

        var a = list.first

        next_ab:
        while counter < n {
            let b = list.next(a)
            let ab = matrix[a.index, b.index]

            var c = list.next(b)
            var d = list.next(c)
            repeat {
                let cd = matrix[c.index, d.index]
                let bd = matrix[b.index, d.index]
                let ac = matrix[a.index, c.index]

                if bd + ac < ab + cd {
                    list.turnOver(start: b, end: c)
                    a = list[a.index]
                    continue next_ab
                }

                c = d
                d = list.next(d)
            } while d != a
            
            a = b
            counter += 1
        }
    }
    
    func reGroup(list: inout LinkedList, matrix: AdjacencyMatrix) {
        let n = matrix.size
        var counter = 0

        var a = list.first

        next_ab:
        while counter < n {
            let b = list.next(a)
            let ab = matrix[a.index, b.index]

            var c0 = b
            var c1 = list.next(c0)
            repeat {
                let c0c1 = matrix[c0.index, c1.index]
                let bc1 = matrix[b.index, c1.index]
                
                var d0 = c1
                var d1 = list.next(c1)
                
                while d1 != a {
                    let c0d1 = matrix[c0.index, d1.index]
                    let d0d1 = matrix[d0.index, d1.index]
                    let ad0 = matrix[a.index, d0.index]
                    
                    if c0d1 + ad0 + bc1 < ab + c0c1 + d0d1 {
                        list.reverse(start: c1, end: d0)
                        list.connect(first: a, next: d0)
                        list.connect(first: c1, next: b)
                        list.connect(first: c0, next: d1)
                        
                        a = list[a.index]
                        
                        continue next_ab
                    }
                    
                    d0 = d1
                    d1 = list.next(d1)
                }
                
                c0 = c1
                c1 = list.next(c1)
            } while c1 != a
            
            a = b
            counter += 1
        }
    }
    
    func joinNearest(list: inout LinkedList, matrix: AdjacencyMatrix) {
        let n = matrix.size
        var counter = 0

        var a = list.first

        next_ab:
        while counter < n {
            let b = list.next(a)
            let old_ab = matrix[a.index, b.index]

            var c = list.next(b)
            repeat {
                let new_cc = matrix[c.prev, c.next]
                let old_cc = matrix[c.prev, c.index] + matrix[c.index, c.next]
                let new_ab = matrix[a.index, c.index] + matrix[c.index, b.index]
                
                if new_cc + new_ab < old_cc + old_ab {
                    list.connect(first: a, next: c)
                    list.connect(first: c, next: b)
                    list.connect(first: c.prev, next: c.next)
                    
                    a = list[a.index]
                    
                    continue next_ab
                }
                c = list.next(c)
            } while c != a
            
            a = b
            counter += 1
        }
    }
    
    func optimizePath(list: inout LinkedList, node: Int, matrix: AdjacencyMatrix) -> Bool {
        let a = list[node]
        let b = list[a.next]

        var ln: CGFloat = 0
        var newIndices = [Int]()
        var oldIndices = list.path(start: b.index, end: a.index)
        var c0 = list.next(b)
        repeat {
            let c1 = list.next(c0)
            
            
            
            
            c0 = c1
        } while c0 != a
        
        return false
    }

}

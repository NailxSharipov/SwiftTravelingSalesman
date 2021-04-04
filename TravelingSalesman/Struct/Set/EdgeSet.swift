//
//  EdgeSet.swift
//  TravelingSalesman
//
//  Created by Nail Sharipov on 29.03.2021.
//

struct EdgeSet {

    let size: Int
    private (set) var count: Int
    private var array: [StaticList]

    var edgesCount: Int {
        var result = 0
        for list in array where list.count > 0 {
            result += 1
        }
        return result
    }
    
    var rest: [Int] {
        var result = [Int]()
        result.reserveCapacity(2)
        for i in 0..<array.count where array[i].count > 0 {
            result.append(i)
        }
        return result
    }
    
    @inline(__always)
    subscript(a: Int, b: Int) -> Bool {
        get {
            array[a][b]
        }
        set {
            var set = array[a]
            guard set[b] != newValue else { return }
            
            if newValue {
                set[b] = true
                count += 1
            } else {
                set[b] = false
                count -= 1
            }
            
            array[a] = set
        }
    }
    
    @inline(__always)
    subscript(a: Int) -> StaticList {
        get {
            array[a]
        }
    }

    init(size: Int, array: [StaticList], count: Int) {
        self.size = size
        self.array = array
        self.count = count
    }
    
    init(size: Int, isOptimal: Bool) {
        self.size = size
        self.array = .init(repeating: StaticList(size: size, isOptimal: true), count: size)
        if isOptimal {
            self.count = size * size
        } else {
            self.count = 0
        }
    }
    
    func values(a: Int) -> [Int] {
        array[a].values
    }

    mutating func subtract(set: UnoptimalEdgeMatrix) {
        for a in 0..<size {
            var list = array[a]
            
            let before = list.count
            list.subtract(a: a, set: set)
            let after = list.count
            
            if after != before {
                array[a] = list
                self.count += before - after
            }
        }
    }
    
    mutating func removeAll(start: Int) {
        let list = array[start]
        if list.count != 0 {
            self.count += list.count
            array[start].removeAll()
        }
    }
    
    mutating func remove(a: Int, ends: [Int]) {
        var list = array[a]
        if list.count != 0 {
            let before = list.count
            for e in ends {
                list.remove(index: e)
            }
            let after = list.count
            
            if after != before {
                array[a] = list
                self.count += before - after
            }
        }
    }
    
}

extension EdgeSet: CustomStringConvertible {
    
    var description: String {
        var result = String()
        for a in 0..<size {
            var addAnithing = false
            for b in 0..<size {
                if self[a, b] {
                    addAnithing = true
                    result.append("\(a)-\(b) ")
                }
            }
            if addAnithing {
                result.append("\n")
            }
        }
        
        return result
    }
}

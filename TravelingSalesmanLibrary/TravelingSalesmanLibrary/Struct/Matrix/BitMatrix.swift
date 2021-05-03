//
//  BitMatrix.swift
//  TravelingSalesmanLibrary
//
//  Created by Nail Sharipov on 20.04.2021.
//

struct BitMatrix {

    enum Fill {
        case empty
        case full
        case identity
        case reverseIdentity
    }
    
    /// 1 - has a connection
    /// 0 - no connection
    fileprivate let array: UnsafeMutablePointer<UInt64>
    
    @inline(__always)
    subscript(i: Int, j: Int) -> Bool {
        get {
            array[i].isBit(index: j)
        }
        set {
            if newValue {
                array[i] = array[i].setBit(index: j)
            } else {
                array[i] = array[i].clearBit(index: j)
            }
        }
    }
    
    @inline(__always)
    subscript(i: Int) -> UInt64 {
        get {
            array[i]
        }
        set {
            array[i] = newValue
        }
    }
    
    let count: Int
    
    init(size: Int, fill: Fill = .empty) {
        count = size
        array = UnsafeMutablePointer<UInt64>.allocate(capacity: size)
        switch fill {
        case .empty:
            array.initialize(repeating: 0, count: size)
        case .full:
            let template: UInt64 = (1 << size) &- 1
            array.initialize(repeating: template, count: size)
        case .identity:
            array.initialize(repeating: 0, count: size)
            for i in 0..<size {
                self[i, i] = true
            }
        case .reverseIdentity:
            let template: UInt64 = (1 << size) &- 1
            array.initialize(repeating: template, count: size)
            for i in 0..<size {
                self[i, i] = false
            }
        }
    }
    
    init(array: UnsafeMutablePointer<UInt64>, size: Int) {
        self.count = size
        self.array = array
    }
    
    func deallocate() {
        array.deinitialize(count: count)
        array.deallocate()
    }
    
    @inline(__always)
    func union(map: BitMatrix) -> BitMatrix {
        let buffer = UnsafeMutablePointer<UInt64>.allocate(capacity: count)
        
        var i = 0
        while i < count {
            buffer[i] = array[i] | map.array[i]
            i &+= 1
        }
        
        return BitMatrix(array: buffer, size: count)
    }
    
    @inline(__always)
    mutating func formUnion(map: BitMatrix) {
        var i = 0
        while i < count {
            array[i] = array[i] | map.array[i]
            i &+= 1
        }
    }
    
    
    @inline(__always)
    func intersect(map: BitMatrix) -> BitMatrix {
        let buffer = UnsafeMutablePointer<UInt64>.allocate(capacity: count)
        
        var i = 0
        while i < count {
            buffer[i] = array[i] & map.array[i]
            i &+= 1
        }
        
        return BitMatrix(array: buffer, size: count)
    }
    
    @inline(__always)
    func intersect(map: BitMatrix, result: inout BitMatrix) {
        var i = 0
        while i < count {
            result.array[i] = array[i] & map.array[i]
            i &+= 1
        }
    }
    
    @inline(__always)
    mutating func formIntersect(map: BitMatrix) {
        var i = 0
        while i < count {
            array[i] = array[i] & map.array[i]
            i &+= 1
        }
    }
    
    @inline(__always)
    func subtract(map: BitMatrix) -> BitMatrix {
        let buffer = UnsafeMutablePointer<UInt64>.allocate(capacity: count)
        var i = 0
        while i < count {
            buffer[i] = array[i].subtract(word: map.array[i])
            i &+= 1
        }
        
        return BitMatrix(array: buffer, size: count)
    }
    
    @inline(__always)
    mutating func formSubtract(map: BitMatrix) {
        var i = 0
        while i < count {
            array[i] = array[i].subtract(word: map.array[i])
            i &+= 1
        }
    }
    
    @inline(__always)
    func invert() -> BitMatrix {
        let buffer = UnsafeMutablePointer<UInt64>.allocate(capacity: count)
        var i = 0
        while i < count {
            buffer[i] = ~array[i]
            i &+= 1
        }
        
        return BitMatrix(array: buffer, size: count)
    }
    
    @inline(__always)
    mutating func formInvert() {
        for i in 0..<count {
            array[i] = ~array[i]
        }
    }
    
    func testConnectivity(mask: UInt64, visited: UInt64, count: Int) -> Bool {
        let n = self.count
        var mask = mask
        var visited = visited
        
        var j = 1
        var nextMask: UInt64 = 0
        
        repeat {
            for i in 0..<n {
                if mask.isBit(index: i) {
                    visited = visited.setBit(index: i)
                    let word = array[i]
                    nextMask = nextMask | word
                    j += 1
                }
            }
            mask = nextMask.subtract(word: visited)
            nextMask = 0
        } while mask != 0

        return j == count
    }
    
    @inline(__always)
    func connectivityFactor(start: Int, visited: UInt64) -> Int {
        let first = self[start].firstBitNotInMask(mask: visited)
        guard first != -1 else {
            return -1
        }

        var visited = visited.setBit(index: first)
        var mask = self[first].subtract(word: visited)

        var j = 1
        repeat {
            var a = mask
            var i = 0
            var nextMask: UInt64 = 0
            while a > 0 {
                let isBit = a & 1 == 1
                if isBit {
                    visited = visited.setBit(index: i)
                    nextMask = nextMask | array[i]
                    j &+= 1
                }
                i &+= 1
                a >>= 1
            }
            mask = nextMask.subtract(word: visited)
        } while mask != 0

        return j
    }
    
    @inline(__always)
    func isClosed(index: Int, a: Int, b: Int) -> Bool {
        var mask = self[index]
        mask = mask.clearBit(index: a).clearBit(index: b)
        return mask == 0
    }

    @inline(__always)
    func isConnected(index: Int) -> Bool {
        for i in 0..<count where array[i].isBit(index: index) {
            return true
        }
        return false
    }
    
}

extension BitMatrix: CustomStringConvertible {
    
    var description: String {
        var result = String()
        let last = count - 1
        
        
        result.append("\r\n")
        result.append("   ")
        for i in 0...last {
            result.append(String(format:"%2X ", i))
        }
        result.append("\r\n")
        
        var i = 0
        for j in 0..<count {
            let a = array[j]
            if i < 16 {
                result.append(String(format:" %X:", i))
            } else {
                result.append(String(format:"%X:", i))
            }
            
            for i in 0...last {
                if a.isBit(index: i) {
                    result.append(" 1 ")
                } else {
                    result.append(" 0 ")
                }
            }
            result.append("\r\n")
            i += 1
        }
        return result
    }
}

extension BitMatrix: CustomDebugStringConvertible {
    var debugDescription: String {
        self.description
    }
}

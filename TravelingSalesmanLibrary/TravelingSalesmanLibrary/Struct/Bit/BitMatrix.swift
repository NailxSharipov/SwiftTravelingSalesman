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
    fileprivate (set) var array: [UInt64]
    
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
    
    init(size: Int, fill: Fill = .empty) {
        switch fill {
        case .empty:
            array = [UInt64](repeating: 0, count: size)
        case .full:
            let template: UInt64 = (1 << size) &- 1
            array = [UInt64](repeating: template, count: size)
        case .identity:
            array = [UInt64](repeating: 0, count: size)
            for i in 0..<size {
                self[i, i] = true
            }
        case .reverseIdentity:
            let template: UInt64 = (1 << size) &- 1
            array = [UInt64](repeating: template, count: size)
            for i in 0..<size {
                self[i, i] = false
            }
        }
    }
    
    init(array: [UInt64]) {
        self.array = array
    }
    
    @inline(__always)
    func union(map: BitMatrix) -> BitMatrix {
        let n = array.count
        var buffer = [UInt64](repeating: 0, count: n)
        
        for i in 0..<n {
            buffer[i] = array[i] | map.array[i]
        }
        
        return BitMatrix(array: buffer)
    }
    
    @inline(__always)
    mutating func formUnion(map: BitMatrix) {
        let n = array.count
        for i in 0..<n {
            array[i] = array[i] | map.array[i]
        }
    }
    
    
    @inline(__always)
    func intersect(map: BitMatrix) -> BitMatrix {
        let n = array.count
        var buffer = [UInt64](repeating: 0, count: n)
        
        for i in 0..<n {
            buffer[i] = array[i] & map.array[i]
        }
        
        return BitMatrix(array: buffer)
    }
    
    @inline(__always)
    mutating func formIntersect(map: BitMatrix) {
        let n = array.count
        for i in 0..<n {
            array[i] = array[i] & map.array[i]
        }
    }
    
    @inline(__always)
    func subtract(map: BitMatrix) -> BitMatrix {
        let n = array.count
        var buffer = [UInt64](repeating: 0, count: n)
        for i in 0..<n {
            buffer[i] = array[i].subtract(word: map.array[i])
        }
        
        return BitMatrix(array: buffer)
    }
    
    @inline(__always)
    mutating func formSubtract(map: BitMatrix) {
        let n = array.count
        for i in 0..<n {
            array[i] = array[i].subtract(word: map.array[i])
        }
    }
    
    @inline(__always)
    func invert() -> BitMatrix {
        let n = array.count
        var buffer = [UInt64](repeating: 0, count: n)
        for i in 0..<n {
            buffer[i] = ~array[i]
        }
        
        return BitMatrix(array: buffer)
    }
    
    @inline(__always)
    mutating func formInvert() {
        let n = array.count
        for i in 0..<n {
            array[i] = ~array[i]
        }
    }

    func testConnectivity(count: Int) -> Bool {
        let n = array.count
        var mask: UInt64 = 0
        var visited: UInt64 = 0
        var target: UInt64 = 0
        var first = 0
        for i in 0..<n {
            let word = array[i]
            target = target | word
            if word > 0 && mask == 0 {
                mask = word
                visited = visited.setBit(index: i)
                first = i
            }
        }

        guard mask != 0 && target.isBit(index: first) else {
            return false
        }
        
        var j = 1
        var nextMask: UInt64 = 0
        
        repeat {
            var i = 0
            while mask > 0 {
                if 1 & mask == 1 {
                    visited = visited.setBit(index: i)
                    let word = array[i]
                    nextMask = nextMask | word
                    j += 1
                }
                mask = mask >> 1
                i += 1
            }
            mask = nextMask.subtract(word: visited)
            nextMask = 0
        } while mask != 0

        return j == count
    }
    
    func testConnectivity(mask: UInt64, visited: UInt64, count: Int) -> Bool {
        let n = array.count
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
        guard first != -1 else { return 0 }

        var visited = visited.setBit(index: first)
        
        var mask = self[first].subtract(word: visited) // TODD may be not needed

        var j = 1
        var nextMask: UInt64 = 0
        
        let n = array.count
        
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
        let n = array.count
        for i in 0..<n where array[i].isBit(index: index) {
            return true
        }
        return false
    }
    
}

extension BitMatrix: CustomStringConvertible {
    
    var description: String {
        var result = String()
        let last = array.count - 1
        
        
        result.append("\r\n")
        result.append("   ")
        for i in 0...last {
            result.append(String(format:"%2X ", i))
        }
        result.append("\r\n")
        
        var i = 0
        for a in array {
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

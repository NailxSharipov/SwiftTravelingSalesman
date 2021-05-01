//
//  UInt64+Bit.swift
//  TravelingSalesmanLibrary
//
//  Created by Nail Sharipov on 20.04.2021.
//

extension UInt64 {
    
    init(mask: [Int]) {
        var a: UInt64 = 0
        for i in mask {
            a = a | (1 << i)
        }
        self = a
    }
    
    @inline(__always)
    func firstBitNotEmpty(size: Int = UInt64.bitWidth) -> Int {
        for i in 0..<size {
            if self.isBit(index: i) {
                return i
            }
        }
        return -1
    }
    
    @inline(__always)
    func firstBitNotInMask(mask: UInt64, size: Int = UInt64.bitWidth) -> Int {
        for i in 0..<size {
            let bit: UInt64 = (1 << i)
            if (bit & self == bit) && (bit & mask != bit) {
                return i
            }
        }
        return -1
    }
    
    @inline(__always)
    func isBit(index: Int) -> Bool {
        let bit: UInt64 = (1 << index)
        return bit & self == bit
    }
    
    @inline(__always)
    func setBit(index: Int) -> UInt64 {
        let bit: UInt64 = (1 << index)
        return self | bit
    }
    
    @inline(__always)
    func clearBit(index: Int) -> UInt64 {
        let bit: UInt64 = (1 << index)
        return self & (UInt64.max &- bit)
    }
    
    @inline(__always)
    func subtract(word: UInt64) -> UInt64 {
        self & (UInt64.max &- word)
    }

    func bitDescription(_ length: Int = UInt64.bitWidth) -> String {
        var result = String()
        let last = length &- 1
        for i in 0...last {
            if self.isBit(index: last &- i) {
                result.append("1")
            } else {
                result.append("0")
            }
        }
        return result
    }
}

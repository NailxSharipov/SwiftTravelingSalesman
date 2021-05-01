//
//  Path64.swift
//  TravelingSalesmanLibrary
//
//  Created by Nail Sharipov on 24.04.2021.
//
/*
struct Path64: Equatable {
    
    private var w0: UInt64 = 0
    private var w1: UInt64 = 0
    private var w2: UInt64 = 0
    private var w3: UInt64 = 0
    private var w4: UInt64 = 0
    private var w5: UInt64 = 0
    private var w6: UInt64 = 0
    private var w7: UInt64 = 0
    private let mask: UInt64
    
    @inline(__always)
    private subscript(index: Int) -> UInt64 {
        get {
            switch index {
            case 0:
                return w0
            case 1:
                return w1
            case 2:
                return w2
            case 3:
                return w3
            case 4:
                return w4
            case 5:
                return w5
            case 6:
                return w6
            default:
                return w7
            }
        }
        set {
            switch index {
            case 0:
                w0 = newValue
            case 1:
                w1 = newValue
            case 2:
                w2 = newValue
            case 3:
                w3 = newValue
            case 4:
                w4 = newValue
            case 5:
                w5 = newValue
            case 6:
                w6 = newValue
            default:
                w7 = newValue
            }
        }
    }
    
    
    init(array: [UInt8]) {
        self.mask = UInt64(mask: array)
        
        var i = 0
        var j = 0
        var w: UInt64 = 0
        var s = 0

        for a in array {
            w &+= UInt64(a) << s
            i += 1
            s += 6
            if i == 4 {
                self[j] = w
                w = 0
                i = 0
                j += 1
            }
        }
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        guard lhs.mask == rhs.mask else {
            return false
        }
        
        return
            lhs.w0 == rhs.w0 &&
            lhs.w1 == rhs.w1 &&
            lhs.w2 == rhs.w2 &&
            lhs.w3 == rhs.w3 &&
            lhs.w4 == rhs.w4 &&
            lhs.w5 == rhs.w5 &&
            lhs.w6 == rhs.w6 &&
            lhs.w7 == rhs.w7
    }
}

extension Path64: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(mask)
    }
}
*/

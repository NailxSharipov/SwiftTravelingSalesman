//
//  FixSizeArray.swift
//  TravelingSalesmanLibrary
//
//  Created by Nail Sharipov on 18.04.2021.
//

struct FixSizeArray {
    
    var count: Int
    private var buffer: [Int]
    
    @inline(__always)
    subscript(index: Int) -> Int {
        get {
            buffer[index]
        }
        set {
            self.buffer[index] = newValue
        }
    }
    
    init(size: Int) {
        buffer = [Int](repeating: -1, count: size)
        count = 0
    }

}

extension FixSizeArray: CustomStringConvertible {
    
    var description: String {
        let content = buffer[0..<count].map({ String($0) }).joined(separator: ", ")
        return "[\(content)]"
    }
}

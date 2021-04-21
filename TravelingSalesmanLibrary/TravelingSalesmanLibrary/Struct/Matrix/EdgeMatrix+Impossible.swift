//
//  EdgeMatrix+Impossible.swift
//  TravelingSalesmanLibrary
//
//  Created by Nail Sharipov on 15.04.2021.
//

extension EdgeMatrix {

    func impossibleHordes() -> [Edge] {
        let connectivity = size - 3
        let emptySet = EdgeSet(size: size, isOptimal: true)
        var result = [Edge]()
        for a in 0..<size {
            var aSet = emptySet
            aSet.removeAny(end: a)
            for b in 0..<size where a != b {
                var set = aSet
                set.subtract(set: self[a, b])
                let c = set.array[b].first
                set.removeAny(start: b)

//                print(set)
                let setConnectivityCount = set.connectivityCount(index: c)
                
                if setConnectivityCount < connectivity {
                    result.append(Edge(a: a, b: b))
                }
            }
        }
        
        return result
    }
    
    func possibleSteps() -> [Edge] {
        let connectivity = size - 3
        let emptySet = EdgeSet(size: size, isOptimal: true)
        var result = [Edge]()
        for a in 0..<size {
            var aSet = emptySet
            aSet.removeAny(end: a)
            for b in 0..<size where a != b {
                var set = aSet
                set.subtract(set: self[a, b])
                let c = set.array[b].first
                set.removeAny(start: b)

                let setConnectivityCount = set.connectivityCount(index: c)
                
                if setConnectivityCount >= connectivity {
                    result.append(Edge(a: a, b: b))
                }
            }
        }
        
        return result
    }
}

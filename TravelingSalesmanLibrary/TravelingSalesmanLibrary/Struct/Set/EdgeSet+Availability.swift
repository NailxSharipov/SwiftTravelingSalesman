//
//  EdgeSet+Availability.swift
//  TravelingSalesmanLibrary
//
//  Created by Nail Sharipov on 15.04.2021.
//

extension EdgeSet {

    func validateConnectivity(index: Int) -> Bool {
        let visitedCount = self.connectivityCount(index: index)
        return visitedCount == self.edgesCount
    }
    
    func connectivityCount(index: Int) -> Int {
        var visited = [Bool](repeating: false, count: size)
        var visitedCount = 0
        visited[index] = true
        var buffer = [array[index]]
        var nextBuffer = [StaticList]()

        repeat {
            for list in buffer {
                for i in list.values {
                    if !visited[i] {
                        visited[i] = true
                        let nextList = array[i]
                        visitedCount += 1
                        if nextList.count > 0 {
                            nextBuffer.append(nextList)
                        }
                    }
                }
            }
            buffer = nextBuffer
            nextBuffer = [StaticList]()
        } while !buffer.isEmpty
        
        return visitedCount
    }
    
}

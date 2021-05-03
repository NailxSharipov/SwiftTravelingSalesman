//
//  StageState.swift
//  DebugApp
//
//  Created by Nail Sharipov on 14.04.2021.
//

import SwiftUI

final class StageState: ObservableObject {
    
    enum StageType: String, CaseIterable {
        case roadSolution
        case graphReformation
        case splitSurface
        case bruteForce
    }
    
    @Published var current: StageType = .roadSolution
}

//
//  StageState.swift
//  DebugApp
//
//  Created by Nail Sharipov on 14.04.2021.
//

import SwiftUI

final class StageState: ObservableObject {
    
    enum StageType: String, CaseIterable {
        case splitSurface
        case bruteForce
    }
    
    @Published var current: StageType = .splitSurface
}

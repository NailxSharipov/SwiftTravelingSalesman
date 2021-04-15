//
//  StageView.swift
//  DebugApp
//
//  Created by Nail Sharipov on 14.04.2021.
//


import SwiftUI

struct StageView: View {

    @EnvironmentObject var inputSystem: InputSystem
    @ObservedObject private var stageState: StageState
    private let dragAreaState: DragAreaState

    init(state: StageState) {
        self.stageState = state
        self.dragAreaState = DragAreaState()
    }

    var body: some View {
        
        return GeometryReader { geometry in
            ZStack {
                СoordinateView(state: self.dragAreaState).background(Color.white)
                self.content(size: geometry.size).allowsHitTesting(false)
            }.gesture(MagnificationGesture()
                .onChanged { scale in
                    self.dragAreaState.modify(scale: scale)
                }
                .onEnded { scale in
                    self.dragAreaState.apply(scale: scale)
                })
            .gesture(DragGesture()
                .onChanged { data in
                    self.dragAreaState.move(start: data.startLocation, current: data.location)
                }
                .onEnded { data in
                    self.dragAreaState.apply(start: data.startLocation, current: data.location)
                }
            )
        }
    }

    func content(size: CGSize) -> some View {
        self.dragAreaState.sceneSize = size

        self.inputSystem.unsubscribeAll()
        
        switch self.stageState.current {
        case .splitSurface:
            let logic = SplitSurfaceLogic(data: SplitSurfaceData.data)
            self.inputSystem.subscribe(logic)
            self.dragAreaState.dragArea = logic
            
            let scene = SplitSurfaceView(state: self.dragAreaState, logic: logic)
            
            return AnyView(scene)
        case .bruteForce:
            let logic = BruteForceLogic(data: BruteForceData.data)
            self.inputSystem.subscribe(logic)
            self.dragAreaState.dragArea = logic
            
            let scene = BruteForceView(state: self.dragAreaState, logic: logic)
            
            return AnyView(scene)
        }
    }

}

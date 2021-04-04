//
//  ContentView.swift
//  TravelingSalesman
//
//  Created by Nail Sharipov on 06.03.2021.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var inputSystem: InputSystem
    private let dragAreaState = DragAreaState()
    
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
        let stageData = StageData(data: DataStorage.data)
        self.inputSystem.subscribe(stageData)
        dragAreaState.dragArea = stageData
        let scene = SceneView(state: dragAreaState, stageData: stageData)

        return scene
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

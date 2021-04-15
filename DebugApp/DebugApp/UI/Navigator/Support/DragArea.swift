//
//  DragArea.swift
//  DebugApp
//
//  Created by Nail Sharipov on 14.04.2021.
//

import CoreGraphics

protocol DragArea: AnyObject {
    func onStart(start: CGPoint, radius: CGFloat) -> Bool
    func onMove(delta: CGSize)
    func onEnd(delta: CGSize)
}

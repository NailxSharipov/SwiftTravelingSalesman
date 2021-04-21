//
//  Stage.swift
//  DebugApp
//
//  Created by Nail Sharipov on 14.04.2021.
//

import Cocoa

protocol Stage: DragArea, Keyboard {
    var pageIndex: Int { get }
    func onNext()
    func onPrev()
    func onEsk(location: NSPoint)
}

extension Stage {
    func onEsk(location: NSPoint) {}
}

extension Stage {
    func onKeyDown(keyCode: UInt16, location: NSPoint) -> Bool {
        if keyCode == 124 || keyCode == 49 || keyCode == 36 {
            self.onNext()
            return true
        } else if keyCode == 123 {
            self.onPrev()
            return true
        } else if keyCode == 53 {
            self.onEsk(location: location)
            return true
        } else {
            return false
        }
    }
}

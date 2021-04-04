//
//  Stage.swift
//  TravelingSalesman
//
//  Created by Nail Sharipov on 06.03.2021.
//

protocol Stage: DragArea, Keyboard {
    var pageIndex: Int { get }
    func onNext()
    func onPrev()
}

extension Stage {
    func onKeyDown(keyCode: UInt16) -> Bool {
        if keyCode == 124 || keyCode == 49 || keyCode == 36 {
            self.onNext()
            return true
        } else if keyCode == 123 {
            self.onPrev()
            return true
        } else {
            return false
        }
    }
}

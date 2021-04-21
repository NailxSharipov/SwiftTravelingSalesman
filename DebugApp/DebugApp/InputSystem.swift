//
//  InputSystem.swift
//  DebugApp
//
//  Created by Nail Sharipov on 14.04.2021.
//

import SwiftUI

protocol Keyboard: AnyObject {
    func onKeyDown(keyCode: UInt16, location: CGPoint) -> Bool
}

final class InputSystem: ObservableObject {

    private final class Subscription {
        weak var ref: Keyboard?
        init(ref: Keyboard) {
            self.ref = ref
        }
    }
    
    var origin: CGPoint = .zero
    weak var dragAreaState: DragAreaState?
    private var subscriptions: [Subscription] = []

    @discardableResult
    func onKeyDown(keyCode: UInt16, location: NSPoint) -> Bool {
        assert(Thread.current == Thread.main)
        self.subscriptions = subscriptions.filter({ $0.ref != nil })
        var result = false
        
        let loc = CGPoint(x: location.x - origin.x, y: location.y - origin.y)

        let worldPos = dragAreaState!.world(screen: loc)
        
        for subcription in self.subscriptions {
            result = result || (subcription.ref?.onKeyDown(keyCode: keyCode, location: worldPos) ?? false)
        }
        return result
    }

    func subscribe(_ object: Keyboard) {
        assert(Thread.current == Thread.main)
        self.subscriptions = subscriptions.filter({ $0.ref != nil })
        if !self.subscriptions.contains(where: { $0.ref === object }) {
            self.subscriptions.append(Subscription(ref: object))
        }
    }
    
    func unsubscribe(_ object: Keyboard) {
        assert(Thread.current == Thread.main)
        self.subscriptions = subscriptions.filter({ $0.ref !== object && $0.ref != nil })
    }
    
    func unsubscribeAll() {
        assert(Thread.current == Thread.main)
        self.subscriptions = []
    }
    
}

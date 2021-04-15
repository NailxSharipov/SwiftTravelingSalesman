//
//  DebugApp.swift
//  DebugApp
//
//  Created by Nail Sharipov on 14.04.2021.
//

import Cocoa
import SwiftUI

@main
struct DebugApp: App {
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            StageNavigator()
        }
    }
}

final class AppDelegate: NSObject, NSApplicationDelegate {

    final class CustomWindow: NSWindow {
        
        let inputSystem = InputSystem()
        
        override func keyDown(with: NSEvent) {
            if !self.inputSystem.onKeyDown(keyCode: with.keyCode) {
                super.keyDown(with: with)
            }
        }
    }
    
    private var window: CustomWindow?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        let aWindow = CustomWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        aWindow.center()
        aWindow.setFrameAutosaveName("DebugApp")
        
        let contentView = StageNavigator().environmentObject(aWindow.inputSystem)
        
        aWindow.contentView = NSHostingView(rootView: contentView)
        aWindow.makeKeyAndOrderFront(nil)
        
        self.window = aWindow
    }
}


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

    var title: String? {
        get {
            window?.title
        }
        set {
            window?.title = newValue ?? ""
        }
    }
    
    private var window: NSWindow?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        let aWindow = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 1024, height: 768),
            styleMask: [.titled, .closable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        aWindow.setFrameAutosaveName("DebugApp")
        aWindow.contentViewController = CustomController()
        aWindow.center()
        aWindow.makeKeyAndOrderFront(nil)
        aWindow.titlebarSeparatorStyle = .shadow

        
        self.window = aWindow
    }
}

final class CustomController: NSViewController {
    
    private let inputSystem = InputSystem()
    
    override func loadView() {
        let contentView = StageNavigator().environmentObject(self.inputSystem)
        view = NSHostingView(rootView: contentView)
        view.frame = NSRect(x: 0, y: 0, width: 1024, height: 768)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NSEvent.addLocalMonitorForEvents(matching: NSEvent.EventTypeMask.keyDown, handler: didPress)
    }

    func didPress(event: NSEvent) -> NSEvent {
        var pos = self.view.convert(event.locationInWindow, from: nil)
        pos.y -= 30 // title offset
        self.inputSystem.onKeyDown(keyCode: event.keyCode, location: pos)
        return event
    }
}

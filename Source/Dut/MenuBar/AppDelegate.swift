//
//  AppDelegate.swift
//  Dut
//
//  Created by Burak Kaya on 7.10.2022.
//

import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    
    static var popover = NSPopover()
    var statusBar: StatusBarController?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        
        Self.popover.contentViewController = NSHostingController(rootView: PopoverView().environment(\.managedObjectContext, PersistenceController.shared.container.viewContext))
        
        Self.popover.behavior = .transient
        // Self.popover.backgroundColor = NSColor(white: 1, alpha: 1)
        
        statusBar = StatusBarController(Self.popover)
        
        NSApp.setActivationPolicy(.accessory)
        
    }
    
}
 

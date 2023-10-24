//
//  MenuBarController.swift
//  Dut
//
//  Created by Burak Kaya on 7.10.2022.
//

import AppKit

class StatusBarController {
    
    private var statusBar: NSStatusBar
    private var statusItem: NSStatusItem
    private var popover: NSPopover
    // private var eventMonitor: EventMonitor?
    
    init(_ popover: NSPopover) {
        
        self.popover = popover
        statusBar = .init()
        
        statusItem = statusBar.statusItem(withLength: 36)
        
        if let button = statusItem.button {
            button.image  = NSImage(systemSymbolName: "checklist", accessibilityDescription: nil)
            button.action = #selector(showPopover(sender:))
            button.target = self
        }
        
        // eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown], handler: mouseEventHandler)
        
    }
    
    @objc
    func showPopover(sender: AnyObject){
        if popover.isShown {
            hidePopover(sender)
        } else {
            
            guard let statusButton = statusItem.button else { return }
            
            popover.contentSize = NSSize(width: 400, height: 460)
            popover.show(relativeTo: statusButton.bounds, of: statusButton, preferredEdge: .maxY)
            
            // eventMonitor?.start()
        }
    }
    
    func hidePopover(_ sender: AnyObject) {
        popover.performClose(sender)
        // eventMonitor?.stop()
    }
    
    func mouseEventHandler(_ event: NSEvent?) {
        if(popover.isShown) {
            hidePopover(event!)
        }
    }
    
}

//
//  DutApp.swift
//  Dut
//
//  Created by Burak Kaya on 7.10.2022.
//

import SwiftUI

@main
struct DutApp: App {
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        Settings {
            EmptyView()
        }
        .commands {
            CommandMenu("Edit") {
                Section {

                    // Select All
                    Button("Select All") {
                        NSApp.sendAction(#selector(NSText.selectAll(_:)), to: nil, from: nil)
                    }
                    .keyboardShortcut("a")
                    
                    // Cut
                    Button("Cut") {
                        NSApp.sendAction(#selector(NSText.cut(_:)), to: nil, from: nil)
                    }
                    .keyboardShortcut("x")
                    
                    // Copy
                    Button("Copy") {
                        NSApp.sendAction(#selector(NSText.copy(_:)), to: nil, from: nil)
                    }
                    .keyboardShortcut("c")
                    
                    // Paste
                    Button("Paste") {
                        NSApp.sendAction(#selector(NSText.paste(_:)), to: nil, from: nil)
                    }
                    .keyboardShortcut("v")
                    
                }
            }
        }
    }
}

//
//  DisplayMode.swift
//  Dut
//
//  Created by Burak Kaya on 10.10.2022.
//

import SwiftUI

enum DisplayMode: String, CaseIterable {
    
    case light = "Light"
    case dark = "Dark"
    case auto = "Auto"
    
    static func changeDisplayMode(to mode: DisplayMode) {

      @AppStorage("displayMode") var displayMode = DisplayMode.auto

      displayMode = mode

      switch mode {
      case .light:
        NSApp.appearance = NSAppearance(named: .aqua)
      case .dark:
        NSApp.appearance = NSAppearance(named: .darkAqua)
      case .auto:
        NSApp.appearance = nil
      }
    }
    
}

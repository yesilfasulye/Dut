//
//  ContentView.swift
//  Dut
//
//  Created by Burak Kaya on 7.10.2022.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        Text("Merhaba").padding(23)
    }

}

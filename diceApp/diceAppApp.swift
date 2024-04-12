//
//  diceAppApp.swift
//  diceApp
//
//  Created by Jonas Bondesson on 2024-04-08.
//

import SwiftUI

@main
struct diceAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(sum: 0, sumAI: 0, winner: "")
        }
    }
}

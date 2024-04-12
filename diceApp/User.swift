//
//  User.swift
//  diceApp
//
//  Created by Jonas Bondesson on 2024-04-08.
//

import Foundation

class User: ObservableObject {
    @Published var cash: Double = 100
    
    func setBet() -> Int {
        self.cash -= 5
        return 5
    }
    
    func win(winnings: Double) {
        self.cash += winnings
    }
    func lose(bet: Double) {
        self.cash -= bet
    }
}

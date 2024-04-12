//
//  User.swift
//  diceApp
//
//  Created by Jonas Bondesson on 2024-04-08.
//

import Foundation

class User: ObservableObject {
    var money: Int = 0
    
    func setBet()-> Int {
        self.money -= 5
        return 5
    }
    
    func win(winnings: Int) {
        self.money += winnings
    }
}

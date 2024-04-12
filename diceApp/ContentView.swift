//
//  ContentView.swift
//  diceApp
//
//  Created by Jonas Bondesson on 2024-04-08.
//

import SwiftUI

struct ContentView: View {
    
    @State var diceNumber1 = 2
    @State var diceNumber2 = 2
    @State var diceNumberAI1 = 2
    @State var diceNumberAI2 = 2
    @State var sum : Int
    @State var sumAI : Int
    @State var ani = false
    @State var aniAI = false
    @State var readyToRoll = false
    @State var winner: String
    @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var timerCounter = 5
    
    var body: some View {
        ZStack {
            Color(red: 38/256, green: 108/256, blue: 59/256)
                .ignoresSafeArea()
            VStack {
                HStack {
                    Dice(diceNumber:diceNumberAI1, animation: aniAI)
                    Dice(diceNumber: diceNumberAI2, animation: aniAI)
                }
                Text("\(winner)")
                    .font(.title)
                    .foregroundColor(.white)
                HStack {
                    Dice(diceNumber: diceNumber1, animation: ani)
                    Dice(diceNumber: diceNumber2, animation: ani)
                }
                .onAppear(perform: {
                    rollAI()
                })
                Button(action: {
                    roll()
                    
                }, label: {
                    Text("Roll")
                        .font(.title)
                        .foregroundColor(.white)
                    
                })
                .padding()
                .background(Color(.red))
                .cornerRadius(15.0)
                
                
            }
            .onReceive(timer, perform: { _ in
                if readyToRoll {
                    readyToRoll = false
                    rollAI()
                }
            })
        }
    }
    
    func rollAI() {
        
        diceNumberAI1 = Int.random(in: 1...6)
        diceNumberAI2 = Int.random(in: 1...6)
        sumAI = diceNumberAI1 + diceNumberAI2
        aniAI.toggle()
        winner = "Higher or lower?"
        
    }
    
    func roll() {
        diceNumber1 = Int.random(in: 1...6)
        diceNumber2 = Int.random(in: 1...6)
        sum = diceNumber1 + diceNumber2
        ani.toggle()
        getWinner()
    }
    
    func getWinner() {
        if sum > sumAI {
            winner = "You win"
        } else if sum < sumAI {
            winner = "AI win"
        } else {
            winner = "It's a draw"
        }
        readyToRoll = true
        
        
    }
    
}

struct Dice: View {
    let diceNumber: Int
    let animation: Bool
    var body: some View {
        Image(systemName: "die.face.\(diceNumber)")
            .resizable()
            .scaledToFit()
            .padding()
            .symbolEffect(.bounce,options: .speed(3), value: animation)
    }
}

#Preview {
    ContentView(sum: 0, sumAI:  0, winner: "")
}

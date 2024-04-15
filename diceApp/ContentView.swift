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
    @State var disableButton = false
    @State var winner: String
    @State var bet = true
    @State var showBet = false
    @StateObject var user = User()
    @State var bid = 0.0
    @State var guessHigh : Bool?
    
    
    @State var timerCounter = 5
    
    var body: some View {
        ZStack {
            Color(red: 38/256, green: 108/256, blue: 59/256)
                .ignoresSafeArea()
            VStack {
                Spacer()
                HStack {
                    Dice(diceNumber:diceNumberAI1, animation: aniAI)
                    Dice(diceNumber: diceNumberAI2, animation: aniAI)
                }
                Text("\(winner)")
                    .textStyleLarge()
                HStack {
                    Dice(diceNumber: diceNumber1, animation: ani)
                    Dice(diceNumber: diceNumber2, animation: ani)
                }
                .onAppear(perform: {
                    rollAI()
                })
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        rollHuman()
                    }, label: {
                        Text("Roll")
                            .buttonTextStyle()
                        
                    })
                    .buttonStyle()
                    .disabled(bid == 0.0)
                    
                    Spacer()
                    
                    Button(action: {
                        showBet.toggle()
                    }, label: {
                        Text("Bet")
                            .buttonTextStyle()
                    })
                    
                    .buttonStyle()
                    
                    
                    Spacer()
                }
                Spacer()
                Text("Your bid: \(bid, specifier: "%.1f")")
                    .textStyleSmall()
                
                HStack {
                    Image(systemName: "dollarsign.circle")
                        .foregroundColor(.white)
                    Text(": \(user.cash, specifier: "%.1f")")
                        .textStyleSmall()
                }
                Spacer()
                
            }
            .sheet(isPresented: $showBet, content: {
                betSheet(user: user, bid: $bid, guessHigh: $guessHigh)
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
    
    func rollHuman() {
        diceNumber1 = Int.random(in: 1...6)
        diceNumber2 = Int.random(in: 1...6)
        sum = diceNumber1 + diceNumber2
        ani.toggle()
        getWinner()
    }
    
    func getWinner() {
        if let higher = guessHigh {
            if (sum > sumAI && higher) || ( sum < sumAI && !higher) {
                winner = "You win"
                user.win(winnings: bid * 2)
            } else if sum == sumAI {
                winner = "It's a draw, no one wins"
            } else {
                winner = "You lose!"
                user.lose(bet: bid)
            }
        }
        if user.cash < 0.1 {
            user.cash = 100.0
        }
        bid = 0.0
        let timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: {timer in
            
                rollAI()
            timer.invalidate()
        })
        
        
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

struct betSheet: View {
    
    @Environment(\.dismiss) var dismiss
    @ObservedObject var user = User()
    @Binding var bid : Double
    @Binding var guessHigh: Bool?
//    @State var cash = 100.0
    var body: some View {
        ZStack {
            Color(red: 38/256, green: 108/256, blue: 59/256)
                .ignoresSafeArea()
            VStack {
                Spacer()
                Text("Place your bets!")
                    .textStyleLarge()
                Spacer()
                Slider(value: $bid, in: 0 ... user.cash)
                Text("Your bet: \(bid, specifier: "%.1f")")
                    .textStyleSmall()
                    
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        guessHigh = true
                        dismiss()
                    }, label: {
                        Text("Higher")
                            .buttonTextStyle()
                    })
                    .buttonStyle()
                    Spacer()
                    Button(action: {
                        guessHigh = false
                        dismiss()
                    }, label: {
                        Text("Lower")
                            .buttonTextStyle()
                    })
                    .buttonStyle()
                    Spacer()
                }
                Spacer()
            }
        }
    }
}

struct ButtonModifiers : ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 40)
            .padding(.vertical, 10)
            .background(Color(.red))
            .cornerRadius(15.0)
    }

}
struct ButtonTextModifers: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            .fontWeight(.bold)
    }
}
struct textModifiersSmall: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .font(.body)
    }
}
struct textModifiersBig: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .font(.title)
            .fontWeight(.bold)
    }
}

extension View {
    func buttonStyle() -> some View {
        self.modifier(ButtonModifiers())
    }
    func buttonTextStyle() -> some View {
        self.modifier(ButtonTextModifers())
    }
    func textStyleSmall() -> some View {
        self.modifier(textModifiersSmall())
    }
    func textStyleLarge() -> some View {
        self.modifier(textModifiersBig())
    }
}

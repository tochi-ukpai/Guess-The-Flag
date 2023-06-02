//
//  ContentView.swift
//  Guess The Flag
//
//  Created by Theós on 30/05/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var alertMessage = ""
    
    @State private var selectedFlag: Int?
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .foregroundColor(.white)
                    .font(.largeTitle.bold())
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            selectedFlag = number
                            flagTapped(number)
                        } label: {
                            FlagImage(flagName: countries[number])
                                .rotation3DEffect(.degrees(isSelected(flag: number) ? 360 : 0), axis: (x: 0, y: 1, z: 0))
                                .opacity(isUnselected(flag: number) ? 0.25 : 1)
                                .scaleEffect(isUnselected(flag: number) ? 0.8 : 1)
                                .animation(.default, value: selectedFlag)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
            }
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text(alertMessage)
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            score += 1
            scoreTitle = "Correct"
            alertMessage = "Your score is \(score)"
        } else {
            scoreTitle = "Wrong"
            alertMessage = "The selected flag is \(countries[number])"
        }
        showingScore = true
    }
    
    func askQuestion() {
        selectedFlag = nil
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func isSelected(flag number: Int) -> Bool {
        number == selectedFlag
    }
    
    func isUnselected(flag number: Int) -> Bool {
        selectedFlag != nil && !isSelected(flag: number)
    }
}


struct FlagImage: View {
    var flagName: String
    
    var body: some View {
        Image(flagName)
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 5)
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

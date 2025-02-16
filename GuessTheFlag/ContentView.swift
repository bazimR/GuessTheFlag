//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Rishal Bazim on 15/02/25.
//

import SwiftUI

struct ContentView: View {
    @State private var showingScore: Bool = false
    @State private var showingTitle: String = ""
    @State private var scoreCount: Int = 0
    @State private var countries = [
        "Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland",
        "Spain", "UK", "Ukraine", "US",
    ].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    var body: some View {
        ZStack {
            RadialGradient(
                stops: [
                    .init(color: .blue, location: 0.6),
                    .init(color: .cyan, location: 0.6),
                ],
                center: .topLeading,
                startRadius: 300,
                endRadius: 500
            ).ignoresSafeArea()
            VStack {
                Spacer()
                Text("Guess the flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)

                Spacer()
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundColor(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .foregroundColor(.secondary)
                            .font(.largeTitle.weight(.semibold))
                    }

                    ForEach(0..<3) { num in
                        Button {
                            flagTapped(num)
                        } label: {
                            Image(countries[num])
                                .clipShape(.buttonBorder)
                                .shadow(radius: 4)
                        }
                    }

                }.frame(maxWidth: .infinity).padding(.vertical, 30).background(
                    .thinMaterial
                ).clipShape(.rect(cornerRadius: 30))
                Spacer()
                Text("Your score is \(scoreCount)")
                    .font(.title.bold())
                    .foregroundColor(.white)
                Spacer()
                Spacer()
            }.padding()
        }.alert(showingTitle, isPresented: $showingScore) {
            Button("Contine") {
                askQuestion()
            }
        } message: {
            Text("Your score is \(scoreCount)")
        }
    }
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            showingTitle = "Correct answer!"
            scoreCount += 1
        } else {
            showingTitle = "Wrong answer"
        }

        showingScore = true
    }

    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

#Preview {
    ContentView()
}

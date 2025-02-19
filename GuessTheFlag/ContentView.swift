//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Rishal Bazim on 15/02/25.
//

import SwiftUI

struct FlagImage: View {
    var num: Int
    var flagTapped: (Int) -> Void
    var country: String
    var isAnimating: Bool
    var isDisabled: Bool
    var body: some View {
        Button {
            flagTapped(num)
        } label: {
            Image(country)
                .clipShape(.buttonBorder)
                .shadow(radius: 4)
        }.rotation3DEffect(
            .degrees(isAnimating ? 360 : 0),
            axis: (
                x: CGFloat.zero,
                y: 1,
                z: CGFloat.zero
            )
        )
        .opacity(isDisabled ? 0.25 : 1)
        .animation(.default, value: isAnimating)
    }
}

struct ImportentTitle: ViewModifier {
    func body(content: Content) -> some View {
        content.font(.largeTitle).foregroundColor(.blue)
    }
}

extension View {
    func importentTitled() -> some View {
        modifier(ImportentTitle())
    }
}
struct ContentView: View {
    @State private var selectedButton: Int?

    @State private var showingScore: Bool = false
    @State private var showingTitle: String = ""
    @State private var userHearts: Int = 3
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
                ZStack {
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
                            FlagImage(
                                num: num,
                                flagTapped: flagTapped,
                                country: countries[num],
                                isAnimating: selectedButton == num,
                                isDisabled: selectedButton != nil
                                    && selectedButton != num
                            )
                        }

                    }.frame(maxWidth: .infinity).padding(.vertical, 30)
                        .background(
                            .thinMaterial
                        ).clipShape(.rect(cornerRadius: 30))
                    if userHearts == 0 {
                        Color.clear.background(.regularMaterial).clipShape(
                            .rect(cornerRadius: 30))
                        VStack {

                            Text("Your score is \(scoreCount)")
                                .font(.title.bold())
                                .foregroundColor(.secondary)
                            Text("Game over")
                                .font(.title2.bold())
                                .foregroundColor(
                                    .secondary)
                            Button(action: restartGame) {
                                Label("Restart", systemImage: "arrow.clockwise")
                                    .font(.title2)
                                    .padding(.horizontal, 12)
                            }
                            .buttonStyle(.bordered)
                            .controlSize(.large)

                        }
                    }
                }
                Spacer()
                Spacer()
                Spacer()
                HStack {
                    ForEach(0..<userHearts, id: \.self) { _ in
                        Image(systemName: "heart.fill")
                            .foregroundColor(.white)
                            .font(.largeTitle)
                    }

                }
                Spacer()
                Text("Your score is \(scoreCount)")
                    .importentTitled().bold()
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
        selectedButton = number
        if number == correctAnswer {
            showingTitle = "Correct answer!"
            scoreCount += 1
        } else {
            showingTitle =
                "Wrong answer \n Thats the flag of \(countries[number])"
            userHearts -= 1

        }

        showingScore = true
    }

    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        selectedButton = nil
    }

    func restartGame() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        userHearts = 3
        scoreCount = 0
    }
}

#Preview {
    ContentView()
}

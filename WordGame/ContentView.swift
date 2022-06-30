//
//  ContentView.swift
//  WordGame
//
//  Created by Yasin Taşkıran on 28.06.2022.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var handler = ContentHandler()

    var body: some View {
        VStack {
            if handler.gameState == .onProgress {
                HStack {
                    Spacer()
                    VStack {
                        Text("Correct Answers: \(handler.currentCorrectAnswers)")
                            .padding()
                        Text("Wrong Answers: \(handler.currentWrongAnswers)")
                            .padding()
                    }
                }
            }
            Spacer()
            if handler.gameState == .onProgress {
                VStack {
                    Text(handler.currentSpanishWord)
                        .padding()
                        .font(.title)
                    Text(handler.currentEnglishWord)
                        .padding()
                }
            }
            Spacer()
            if handler.gameState != .onProgress {
                VStack {
                    Text((handler.gameState == .ended) ? "Congrats! You have answered \(handler.currentCorrectAnswers) questions correctly" : "Welcome to the Game")
                        .padding()
                        .multilineTextAlignment(.center)
                    Button(action: {
                        handler.startGame()
                    }) {
                        Text((handler.gameState == .initialize) ? "Start the game" : "Restart")
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                            .padding()
                            .border(Color.blue, width: 2)
                    }
                }
            }
            Spacer()
            if handler.gameState == .onProgress {
                HStack {
                    Spacer()
                    Button(action: {
                        handler.evaluateAnswer(userSelected: true)
                    }) {
                        Text("Correct")
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                            .padding()
                            .border(Color.blue, width: 2)
                    }
                    Spacer()
                    Button(action: {
                        handler.evaluateAnswer(userSelected: false)
                    }) {
                        Text("Wrong")
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                            .padding()
                            .border(Color.blue, width: 2)
                    }
                    Spacer()
                }
            }
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

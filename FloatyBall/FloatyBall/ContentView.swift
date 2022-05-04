//
//  ContentView.swift
//  Ships
//
//  Created by Joel Hollingsworth on 4/4/21.
//

import SwiftUI

struct ContentView: View {
    
    @State private var isGameSceneShowing = false
    
    var body: some View {
        
        var diff = ""
        
        HStack{
        VStack{
            Spacer()
            Text("Let's Play")
                .bold()
                .padding()
                .font(.largeTitle)
            Spacer()
            Group{
            Button(action: {
                isGameSceneShowing = true
                diff = "easy"
            }) {
            Text("Easy")
                .font(.largeTitle)
                .foregroundColor(.green)
                .bold()
                .padding()
        }
            //Spacer()
            Button(action: {
                isGameSceneShowing = true
                diff = "normal"
            }) {
                Text("Medium")
                    .font(.largeTitle)
                    .foregroundColor(.orange)
                    .bold()
                    .padding()
            }
            //Spacer()
            Button(action: {
                isGameSceneShowing = true
                diff = "hard"
            }) {
                Text("Hard")
                    .font(.largeTitle)
                    .foregroundColor(.red)
                    .bold()
                    .padding()
                }
            }
            .padding()
            Spacer()
        }
        
        .fullScreenCover(isPresented: $isGameSceneShowing) {
            GameView(difficulty: diff)
        }
    }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct CircleButton: View {
    
    let value: String
    
    var body: some View {
        Circle()
            .fill(Color.orange)
            .shadow(radius: 3)
            .overlay(
                Text(value)
                    .font(.title)
                    .fontWeight(.bold)
            )
    }
}

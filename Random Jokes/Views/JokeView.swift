//
//  JokeView.swift
//  Random Jokes
//
//  Created by Tom Wu on 2023-04-14.
//

import SwiftUI
import Blackbird
struct JokeView: View {
    
    @State var punchlineOpacity = 0.0
    @Environment(\.blackbirdDatabase) var db: Blackbird.Database?
    @State var currentJoke: Joke?
    
    var body: some View {
        NavigationView{
            VStack{
                
                Spacer()
                
                if let currentJoke = currentJoke{
                    Text(currentJoke.setup)
                        .font(.title)
                        .multilineTextAlignment(.center)
                    
                    Button(action: {
                        withAnimation(.easeIn(duration: 1.0)){
                            punchlineOpacity = 1.0
                        }
                    }, label: {Image(systemName: "arrow.down.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40)
                            .tint(.black)
                    })
                    
                    Text(currentJoke.punchline)
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .opacity(punchlineOpacity)
                }else{
                    ProgressView()
                }
                
                Spacer()
                
                Button(action: {
                    // Reset the interface
                    punchlineOpacity = 0.0
                    
                    Task {
                        // Get another joke
                        withAnimation {
                            currentJoke = nil
                        }
                        currentJoke = await NetworkService.fetch()
                    }
                }, label: {
                    Text("Fetch another one")
                })
                .disabled(punchlineOpacity == 0.0 ? true : false)
                .buttonStyle(.borderedProminent)
                
                Button(action: {
                    Task {
                        if let currentJoke = currentJoke {
                            try await db!.transaction { core in
                                try core.query("INSERT INTO Joke (id, type, setup, punchline) VALUES (?,?,?,?)",
                                               currentJoke.id,
                                               currentJoke.type,
                                               currentJoke.setup,
                                               currentJoke.punchline
                                )
                            }
                        }
                    }
                }, label: {
                    Text("Save for later")
                })
                .buttonStyle(.borderedProminent)
                .tint(.green)
                .disabled(punchlineOpacity == 0.0 ? true : false)
            }
            .navigationTitle("Random Jokes")
        }
        .task {
            currentJoke = await NetworkService.fetch()
        }
    }
}

struct JokeView_Previews: PreviewProvider {
    static var previews: some View {
        JokeView()
            .environment(\.blackbirdDatabase, AppDatabase.instance)
    }
}

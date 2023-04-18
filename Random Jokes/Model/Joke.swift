//
//  Joke.swift
//  Random Jokes
//
//  Created by Tom Wu on 2023-04-14.
//

import Foundation
import Blackbird
struct Joke: Identifiable, Codable, BlackbirdModel{
    @BlackbirdColumn var type: String
    @BlackbirdColumn var setup: String
    @BlackbirdColumn var punchline: String
    @BlackbirdColumn var id: Int
}

let exampleJoke = Joke(type: "general", setup: "How much does a hipster weigh?", punchline: "An instagram", id: 146)

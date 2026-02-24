//
//  ContentView.swift
//  SimpsonsApp
//
//  Created by Mario Duarte on 21/02/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Simpsons.id) private var characters: [Simpsons]
    @Query(sort: \SimpsonsEpisodes.id) private var episodes: [SimpsonsEpisodes]
    
    @State private var currentProgress: Int = 0
    let fetcher = FetchService()
    
    @State private var isDownloading = false
    
    var body: some View {
        TabView {
            Character()
                .tabItem {
                    Label("Character", systemImage: "person.2.fill")
                }
            Episodes()
                .tabItem {
                    Label("Episodes", systemImage: "film")
                }
            Location()
                .tabItem {
                    Label("Location", systemImage: "map.fill")
                }
        }
        .tint(.yellow)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Simpsons.self, SimpsonsEpisodes.self, SimpsonsLocations.self],    inMemory: true)
}



// Idade do personagem
//                        Text("Idade: \(character.age != nil ? String(character.age!) : "Unknown")")
//                        Text("Birthdate: \(character.birthdate != nil ? String(character.birthdate!) : "Unknown")")
//                        Text(character.gender)
//                        Text(character.occupation)
//                        Text(character.phrases.first ?? "Nenhuma frase disponível")
//                        Text(character.status)

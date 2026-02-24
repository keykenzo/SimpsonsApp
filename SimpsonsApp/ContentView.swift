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
    @Query(sort: \SimpsonsLocations.id) private var locations: [SimpsonsLocations]
    
    @State private var currentProgress: Double = 0.0
    let fetcher = FetchService()
    
    @State private var isDownloading = false
    @State private var showMainScreen = true
    @State private var donutRotation = 0.0
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
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
                
                if showMainScreen {
                    MainScreen(geo: geo)
                        .transition(.opacity)
                        .onTapGesture {
                            handleStartAction()
                        }
                        .zIndex(1)
                }
                
                if isDownloading {
                    ZStack {
                        Color.black.opacity(0.85).ignoresSafeArea()
                        
                        VStack(spacing: 30) {
                            Image(.donut)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                                .rotationEffect(.degrees(donutRotation))
                                .onAppear {
                                    withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                                        donutRotation = 360
                                    }
                                }
                            
                            VStack {
                                ProgressView(value: currentProgress, total: 100.0)
                                    .progressViewStyle(LinearProgressViewStyle(tint: .yellow))
                                    .padding(.horizontal, 50)
                                
                                HStack {
                                    Text("Eating donuts...")
                                        .font(.custom("SimpsonFont", size: 20))
                                        .foregroundStyle(.white)
                                        .phaseAnimator([true, false]) { content, phase in
                                            content
                                                .scaleEffect(phase ? 1 : 0.9)
                                                .opacity(phase ? 1.0 : 0.7)
                                        } animation: { _ in
                                                .easeInOut(duration: 0.8).repeatForever(autoreverses: true)
                                        }
                                    
                                    Text("\(Int(currentProgress))%")
                                        .font(.custom("SimpsonFont", size: 20))
                                        .foregroundStyle(.white)
                                }
                            }
                        }
                    }
                    .zIndex(2)
                }
            }
        }
    }
    
    private func handleStartAction() {
        if characters.isEmpty || episodes.isEmpty || locations.isEmpty {
            Task {
                await startFullDownload()
            }
        } else {
            withAnimation { showMainScreen = false }
        }
    }
    
    private func startFullDownload() async {
        isDownloading = true
        
        do {
            try await fetchAllCharacters()
            try await fetchAllEpisodes()
            try await fetchAllLocations()
            
            withAnimation {
                isDownloading = false
                showMainScreen = false
            }
        } catch {
            isDownloading = false
        }
    }
    //1182+ characters
    private func fetchAllCharacters() async throws {
        for i in 1...100 {
            let data = try await fetcher.fetchSimpsons(i)
            modelContext.insert(data)
            await MainActor.run { currentProgress = (Double(i)/100) * 40.0  }
        }
        try modelContext.save()
        
        for character in characters {
            if character.imageData == nil, let urlString = character.imageURL, let url = URL(string: urlString) {
                let (data, _) = try await URLSession.shared.data(from: url)
                character.imageData = data
                try modelContext.save()
            }
        }
    }
    //768+ episodes
    private func fetchAllEpisodes() async throws {
        for i in 1...59 {
            let data = try await fetcher.fetchSimpsonsEpisodes(i)
            modelContext.insert(data)
            await MainActor.run { currentProgress = 40.0 + (Double(i)/59.0) * 35 }
        }
        try modelContext.save()
        
        for episode in episodes {
            if episode.imageEpisodeData == nil, let urlString = episode.imageURL, let url = URL(string: urlString) {
                let (data, _) = try await URLSession.shared.data(from: url)
                episode.imageEpisodeData = data
                try modelContext.save()
            }
        }
    }
    //477+ locations
    private func fetchAllLocations() async throws {
        for i in 1...40 {
            let data = try await fetcher.fetchSimpsonsLocations(i)
            modelContext.insert(data)
            await MainActor.run { currentProgress = 75 + (Double(i) / 40.0 ) * 25 }
        }
        try modelContext.save()
        
        for location in locations {
            if location.imageLocationData == nil, let urlString = location.imageURL, let url = URL(string: urlString) {
                let (data, _) = try await URLSession.shared.data(from: url)
                location.imageLocationData = data
                try modelContext.save()
            }
        }
    }
}
#Preview {
    ContentView()
        .modelContainer(for: [Simpsons.self, SimpsonsEpisodes.self, SimpsonsLocations.self], inMemory: true)
}



// Idade do personagem
//                        Text("Idade: \(character.age != nil ? String(character.age!) : "Unknown")")
//                        Text("Birthdate: \(character.birthdate != nil ? String(character.birthdate!) : "Unknown")")
//                        Text(character.gender)
//                        Text(character.occupation)
//                        Text(character.phrases.first ?? "Nenhuma frase disponível")
//                        Text(character.status)

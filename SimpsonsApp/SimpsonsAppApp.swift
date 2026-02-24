//
//  SimpsonsAppApp.swift
//  SimpsonsApp
//
//  Created by Mario Duarte on 21/02/26.
//

import SwiftUI
import SwiftData

@main
struct SimpsonsAppApp: App {
  
    var sharedModelContainer: ModelContainer = {
        
        let schema = Schema([
            Simpsons.self,
            SimpsonsEpisodes.self,
            SimpsonsLocations.self
        ])
        
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            // Se houver um erro crítico (como conflito de versão do banco), o app avisa aqui
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}

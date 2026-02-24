//
//  Persistence.swift
//  SimpsonsApp
//
//  Created by Mario Duarte on 22/02/26.
//

import SwiftData
import Foundation

@MainActor
struct PersistenceController {
    
    
    static var previewSimpsonsCharacter: Simpsons {
        let decoder = JSONDecoder()
        
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let simpsonsData = try! Data(contentsOf: Bundle.main.url(forResource: "samplesimpsoncharacter", withExtension: "json")!)
        
        let simpsonsCharacter = try! decoder.decode(Simpsons.self, from: simpsonsData)
        
        return simpsonsCharacter
    }
    
    static var previewSimpsonsEpisodes: SimpsonsEpisodes {
        let decoder = JSONDecoder()
        
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let simpsonsDataEpisode = try! Data(contentsOf: Bundle.main.url(forResource: "sampleEpisode", withExtension: "json")!)
        
        let simpsonsEpisode = try! decoder.decode(SimpsonsEpisodes.self, from: simpsonsDataEpisode)
        
        return simpsonsEpisode
    }
    
    // our sample preview database
    static let preview: ModelContainer = {
        let schema = Schema([Simpsons.self, SimpsonsEpisodes.self])
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        
        let container = try! ModelContainer(for: schema, configurations: config)
        
        // 2. Insira os dados de exemplo no contexto principal
        container.mainContext.insert(previewSimpsonsCharacter)
        container.mainContext.insert(previewSimpsonsEpisodes)
        
        return container
    }()
    
}

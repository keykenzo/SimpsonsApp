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
    
    // our sample preview database
    static let preview: ModelContainer = {
        let container = try! ModelContainer(for: Simpsons.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        container.mainContext.insert(previewSimpsonsCharacter)
        
        return container
    }()
    
}

//
//  CharacterDetail.swift
//  SimpsonsApp
//
//  Created by Mario Duarte on 22/02/26.
//

import SwiftUI

struct CharacterDetail: View {
    
    var character: Simpsons
    
    var body: some View {
        Text("Hello, World! \(character.name) ")
        
        // Idade do personagem
                                Text("Idade: \(character.age != nil ? String(character.age!) : "Unknown")")
                                Text("Birthdate: \(character.birthdate != nil ? String(character.birthdate!) : "Unknown")")
                                Text(character.gender)
                                Text(character.occupation)
                                Text(character.phrases.first ?? "Nenhuma frase disponível")
                                Text(character.status)
        
        
        
    }
}

#Preview {
    NavigationStack{
        CharacterDetail(character:  PersistenceController.previewSimpsonsCharacter)
    }
}


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
        
        ScrollView {
            VStack(spacing: 0) {
                Image("1")
                    .resizable()
                    .scaledToFit()
                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                    .mask(
                        LinearGradient(
                            gradient: Gradient(stops: [
                                .init(color: .black, location: 0),
                                .init(color: .black, location: 0.5),
                                .init(color: .black, location: 0.6),
                                .init(color: .clear, location: 1)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
//                    .zIndex(1)
                VStack {
                    HStack {
                        Text("\(character.name)")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .frame(maxWidth: 250, alignment: .leading)
                        
                        ZStack {
                            Image(systemName: "bolt.fill")
                                .font(.system(size: 25, weight: .bold))
                                .foregroundColor(.black)
                                .background{
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.simpsonsYellow)
                                        .frame(width: 60, height: 60)
                                }
                        }
                        Spacer()
                    }
                    .padding(.top, 40)
                    .padding(.horizontal, 40)
                    
                    VStack {
                        HStack {
                            Text("AGE \(character.age != nil ? String(character.age!) : "Unknown")")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Capsule().fill(Color.simpsonsYellow))
                            
                            Text(character.occupation)
                                .font(.caption)
                                .foregroundStyle(.simpsonsGray)
                            Spacer()
                        }
                        
                        Text(character.charDescription ?? "")
                            .font(.subheadline)
                            .foregroundStyle(.simpsonsGrayHarder)
                            .padding(.bottom, 40)
                            .padding(.top, 10)
                    }
                    .padding(.horizontal, 40)
                }
                .background(
                    RoundedRectangle(cornerRadius: 45)
//                        .fill(Color(uiColor: .secondarySystemGroupedBackground))
                        .fill(Color(.white))
                        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                )
                .padding(.horizontal)
                .offset(y: -30)
                .padding(.bottom, -30)
            }
        }
        .navigationTitle(character.name.capitalized)
    }
}

#Preview {
    NavigationStack{
        CharacterDetail(character:  PersistenceController.previewSimpsonsCharacter)
    }
}



//        // Idade do personagem
//
//        Text("Birthdate: \(character.birthdate != nil ? String(character.birthdate!) : "Unknown")")
//        Text(character.gender)
//
//        Text(character.phrases.first ?? "Nenhuma frase disponível")
//        Text(character.status)
//        Group {
//            if let data = character.imageData, let uiImage = UIImage(data: data) {
//                Image(uiImage: uiImage)
//                    .resizable()
//                    .scaledToFill()
//            } else {
//                ProgressView()
//            }
//        }

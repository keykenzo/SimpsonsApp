//
//  CharacterDetail.swift
//  SimpsonsApp
//
//  Created by Mario Duarte on 22/02/26.
//

import SwiftUI

struct CharacterDetail: View {
    
    var character: Simpsons
    @State private var isShowingAllPhrases = false
    
    var body: some View {
        
        ScrollView {
            VStack(spacing: 0) {
                        Group {
                            if let data = character.imageData, let uiImage = UIImage(data: data) {
                                Image(uiImage: uiImage)
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
                                    .zIndex(1)
                            } else {
                                ProgressView()
                            }
                        }
                                    
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
                                        .frame(width: 50, height: 50)
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
                
                VStack {
                    VStack {
                        HStack {
                            Text("Famous Quotes")
                                .padding(25)
                                .fontWeight(.bold)
                                .font(.headline)
                            
                            Spacer()
                            
                            Button {
                                isShowingAllPhrases = true
                            } label: {
                                Text("View All")
                                    .foregroundColor(.simpsonsYellow)
                                    .fontWeight(.bold)
                                    .padding(25)
                            }
                        }
                    }
                    .sheet(isPresented: $isShowingAllPhrases) {
                        NavigationStack {
                            if !character.phrases.isEmpty {
                                List(character.phrases, id: \.self) { phrase in
                                    Text(phrase)
                                        .font(.subheadline)
                                        .padding()
                                }
                                .navigationTitle("All Quotes")
                                .navigationBarTitleDisplayMode(.inline)
                                .toolbar {
                                    ToolbarItem(placement: .topBarTrailing) {
                                        Button {
                                            isShowingAllPhrases = false
                                        } label: {
                                            Image(systemName: "xmark")
                                                .imageScale(.large)
                                                .foregroundColor(.gray.opacity(0.6))
                                        }
                                    }
                                }
                            } else {
                                List {
                                    Text("There are no quotes for this character.")
                                        .font(.subheadline)
                                        .padding()
                                }
                                .navigationTitle("All Quotes")
                                .navigationBarTitleDisplayMode(.inline)
                                .toolbar {
                                    ToolbarItem(placement: .topBarTrailing) {
                                        Button {
                                            isShowingAllPhrases = false
                                        } label: {
                                            Image(systemName: "xmark.circle.fill")
                                                .imageScale(.large)
                                                .foregroundColor(.gray.opacity(0.6))
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    if !character.phrases.isEmpty {
                        TabView {
                            ForEach(character.phrases, id: \.self) { phrase in
                                ZStack {
                                    RoundedRectangle(cornerRadius: 25)
                                        .fill(phrase == character.phrases.first ? Color.simpsonsYellow : Color.simpsonsBlueHarder)
                                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                                        
                                    Image(systemName: "quote.closing")
                                        .font(.system(size: 50))
                                        .opacity(phrase == character.phrases.first ? 0.1 : 0.12)
                                        .offset(x: 150, y: 20)
                                        .rotationEffect(.degrees(15))
                                        .foregroundStyle(phrase == character.phrases.first ? Color.black : Color.white)
                                    
                                    Text(phrase)
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                        .italic()
                                        .multilineTextAlignment(.center)
                                        .padding(30)
                                        .foregroundStyle(phrase == character.phrases.first ? Color.black : Color.yellow)
                                }
                                .padding(.horizontal, 25)
                                .padding(.bottom, 40)
                            }
                        }
                        .frame(height: 220)
                        .tabViewStyle(.page(indexDisplayMode: .always))
                        .onAppear {
                            UIPageControl.appearance().currentPageIndicatorTintColor = .systemYellow
                            UIPageControl.appearance().pageIndicatorTintColor = UIColor.systemGray4
                        }
                    } else {
                        TabView {
                            ZStack {
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(Color.simpsonsYellow)
                                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                                
                                Text("There are no quotes for this character.")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .italic()
                                    .multilineTextAlignment(.center)
                                    .padding(30)
                                    .foregroundStyle(Color.black)
                            }
                            .padding(.horizontal, 25)
                            .padding(.bottom, 40)
                        }
                        .frame(height: 220)
                        .tabViewStyle(.page(indexDisplayMode: .always))
                    }
                }
                
//                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
//                    Text("Workplace")
//                    Text("Favorite Food")
//                    Text("Location")
//                    Text("Family Size")
//                }
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


//LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
//    ForEach(pokemon.moves.prefix(4), id: \.self) { move in
//        HStack {
//            Image(systemName: "circle.fill")
//                .font(.system(size: 6))
//                .foregroundColor(.primary.opacity(0.5))
//            
//            Text(move.capitalized)
//                .font(.subheadline)
//                .fontWeight(.semibold)
//        }
//        .padding()
//        .frame(maxWidth: .infinity, alignment: .leading)
//        .background(Color.primary.opacity(0.05))
//        .cornerRadius(12)
//    }
//    }

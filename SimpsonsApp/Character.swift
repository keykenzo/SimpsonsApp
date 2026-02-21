//
//  ContentView.swift
//  SimpsonsApp
//
//  Created by Mario Duarte on 21/02/26.
//

import SwiftUI
import SwiftData

struct Character: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Simpsons.id) private var characters: [Simpsons]
    
    @State private var currentProgress: Int = 0
    let fetcher = FetchService()
    
    @State private var isDownloading = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(characters) { character in
                    HStack(spacing: 15) {
                        Group {
                            if let data = character.imageData, let uiImage = UIImage(data: data) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                            } else {
                                ProgressView()
                            }
                        }
                        .frame(width: 65, height: 65)
                        .background(Color.gray.opacity(0.1))
                        .clipShape(Circle())
                        .overlay {
                            Circle().stroke(.yellow, lineWidth: 3)
                        }
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text(character.name)
                                .font(.headline)
                            
                            Text(character.occupation)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                        }
                        
                        Spacer()
                        
                        ZStack {
                            Circle()
                                .fill(.yellow.opacity(0.2))
                                .frame(width: 30, height: 30)
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.black)
                        }
                    }
                    
                    .padding()
                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
                    
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                }
                .onDelete(perform: deleteItems)
            }
            .listStyle(.plain)
            .navigationTitle("Characters")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        getSimpsonsData(from: 1)
                    } label: {
                        Label("Baixar Dados", systemImage: "icloud.and.arrow.down")
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
            }
            .overlay {
                if characters.isEmpty {
                    ContentUnavailableView("Sem dados",
                                           systemImage: " person.3.sequence",
                                           description: Text("Clique no ícone de nuvem para baixar os personagens."))
                }
            }
        }
        
    }
    

    private func getSimpsonsData(from id: Int) {
        Task {
            for i in id...20 {
                do {
                    let fetchedSimpsonsData = try await fetcher.fetchSimpsons(i)
                    
                    modelContext.insert(fetchedSimpsonsData)
                    await MainActor.run { currentProgress = i }
                } catch {
                    print("Erro ao baixar ID \(i): \(error)")
                }
            }
            storeSprites()
        }
    }
    
    private func storeSprites() {
        Task {
            do {
                // "characters" @Query que traz os dados do SwiftData
                for character in characters {
                    // Só baixa se a imagem ainda não estiver salva e se houver URL
                    if character.imageData == nil, let urlString = character.imageURL, let url = URL(string: urlString) {
                        
                        // Baixa os bytes da imagem
                        let (data, _) = try await URLSession.shared.data(from: url)
                        
                        // Salva os bytes no modelo
                        character.imageData = data
                        
                        // Salva o progresso no banco
                        try modelContext.save()
                        
                        await MainActor.run {
                            currentProgress = character.id
                            print("📸 Imagem salva: \(character.name)")
                        }
                    }
                }
                await MainActor.run { isDownloading = false }
            } catch {
                print("Erro ao salvar imagens: \(error)")
                await MainActor.run { isDownloading = false }
            }
        }
    }
    
    
    private func deleteItems(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(characters[index])
        }
    }
}



#Preview {
    Character()
        .modelContainer(for: Simpsons.self, inMemory: true)
}



// Idade do personagem
//                        Text("Idade: \(character.age != nil ? String(character.age!) : "Unknown")")
//                        Text("Birthdate: \(character.birthdate != nil ? String(character.birthdate!) : "Unknown")")
//                        Text(character.gender)
//                        Text(character.occupation)
//                        Text(character.phrases.first ?? "Nenhuma frase disponível")
//                        Text(character.status)

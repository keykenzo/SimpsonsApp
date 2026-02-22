//
//  Character.swift
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
    @State private var selectedFilter: String = "All"
    @State private var searchText = ""
    
//    var filteredCharacters: [Simpsons] {
//        if searchText.isEmpty {
//            return characters
//        } else {
//            return characters.filter { $0.name.localizedStandardContains(searchText) }
//        }
//    }
    
    @ViewBuilder
    func filterButton(title: String, filter: String) -> some View {
        Button(title) {
            selectedFilter = filter
        }
        .buttonStyle(.borderedProminent)
        .tint(selectedFilter == filter ? .simpsonsYellow : .white)
        .foregroundStyle(.black)
        .clipShape(RoundedRectangle(cornerRadius: 15)) // Garante que o botão siga o raio
        .shadow(color: .black.opacity(selectedFilter == filter ? 0.15 : 0.05),
                radius: selectedFilter == filter ? 8 : 3,
                x: 0, y: 2)
    }
    
    var filteredCharacters: [Simpsons] {
        
        var list = characters
    
        switch selectedFilter {
        case "Family":
            list = list.filter { character in
                let lastName = character.name.components(separatedBy: " ").last ?? ""
                return characters.filter { $0.name.contains(lastName) }.count > 1
            }
            list = list.sorted {
                let last0 = $0.name.components(separatedBy: " ").last ?? ""
                let last1 = $1.name.components(separatedBy: " ").last ?? ""
                return last0 < last1
            }
            
        case "School":
            list = list.filter { $0.occupation.localizedStandardContains("School") }
            
        case "Work":
            list = list.filter { $0.occupation != "Unknown" }
            
        default:
            break
        }
        
        if searchText.isEmpty {
            return list
        } else {
            return list.filter { $0.name.localizedStandardContains(searchText) }
        }
    }
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                HStack {
                    Text("Characters")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    Image(systemName: "person.fill")
                        .padding(.horizontal, 27)
                        .imageScale(.large)
                }
            }
            
            HStack(spacing: 25) {
                VStack {
                    TextField("Search Springfield residents...", text: $searchText)
                        .focused($isFocused)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 15)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color(uiColor: .secondarySystemGroupedBackground))
                                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.gray.opacity(0), lineWidth: 0)
                        )
                }
                .padding(.leading)
                .padding(.bottom)
                
                Button {
                    searchText = ""
                    isFocused = false
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .imageScale(.large)
                        .foregroundColor(.gray.opacity(0.3))
                }
                .padding(.trailing, 16)
                .padding(.bottom)
                .offset(x: -10)
            }
                
            VStack {
                HStack(spacing: 12) {
                    filterButton(title: "All", filter: "All")
                    filterButton(title: "Family", filter: "Family")
                    filterButton(title: "School", filter: "School")
                    filterButton(title: "Work", filter: "Work")
                }
                .padding(.horizontal)
            }
            
            List {
                ForEach(filteredCharacters) { character in
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
//            .searchable(text: $searchText, prompt: "Search a Character")
//            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            
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
            for i in id...150 {
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
                            print("📸 Imagem salva: \(character.id) \(character.name)")
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
            modelContext.delete(filteredCharacters[index])
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

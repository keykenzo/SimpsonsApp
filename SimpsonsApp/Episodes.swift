//
//  Episodes.swift
//  SimpsonsApp
//
//  Created by Mario Duarte on 21/02/26.
//

import SwiftUI
import SwiftData

struct Episodes: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \SimpsonsEpisodes.id) private var episodes: [SimpsonsEpisodes]
    
    let fetcher = FetchService()
        
    @State private var currentProgress: Int = 0
    @State private var selectedSeason: Int = 1
    
    var filteredSeason: [SimpsonsEpisodes] {
        
        return episodes.filter { $0.season == selectedSeason}
        .sorted { $0.id < $1.id }
        
    }
    
    var season: [Int] {
        Array(Set(episodes.map { $0.season })).sorted()
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text("Episodes")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    Image(systemName: "film")
                        .padding(.horizontal, 27)
                        .imageScale(.large)
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(season, id: \.self) { seasonNumber in
                            Button {
                                withAnimation(.spring()) {
                                    selectedSeason = seasonNumber
                                }
                            } label: {
                                Text("Season \(seasonNumber)")
                                    .font(.headline.bold())
                                    .foregroundStyle(selectedSeason == seasonNumber ? Color.black : Color.simpsonsGrayHarder)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 15)
                                    .background {
                                        RoundedRectangle(cornerRadius: 25)
                                            .fill(selectedSeason == seasonNumber ? Color.simpsonsYellow : Color.simpsonsGrayLighter)
                                    }
                            }
                        }
                    }
                    .padding()
                }
            }
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(filteredSeason) { episode in
                        NavigationLink(value: episode) {
                            VStack(alignment: .leading, spacing: 12) {
                                ZStack(alignment: .topLeading) {
                                    if let data = episode.imageEpisodeData, let uiImage = UIImage(data: data) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 200)
                                            .clipped()
                                            .cornerRadius(10)
                                        
                                        HStack(spacing: 4) {
                                            Text("S\(episode.season)")
                                            Text("E\(episode.id)")
                                        }
                                        .font(.caption.bold())
                                        .foregroundStyle(.black)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background {
                                            RoundedRectangle(cornerRadius: 20)
                                                .fill(Color.simpsonsYellow)
                                        }
                                        .padding(10)
                                        
                                    } else {
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.gray.opacity(0.2))
                                            .frame(height: 200)
                                            .overlay {
                                                ProgressView()
                                            }
                                    }
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(episode.name)
                                        .font(.headline)
                                        .fontWeight(.bold)
                                    
                                    if !(episode.airdate?.isEmpty ?? true) {
                                        Text(episode.airdate!)
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    } else {
                                        Text("No airdate available")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                    
                                    Text(episode.synopsis.isEmpty ? "No Synopsis for this episode" : episode.synopsis)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                        .lineLimit(3)
                                }
                                .padding(.horizontal, 10)
                                .padding(.bottom, 10)
                            }
                            .background(Color(uiColor: .systemBackground))
                            .cornerRadius(10)
                            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                            .padding(.horizontal)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.vertical)
                }
                .navigationDestination(for: SimpsonsEpisodes.self) { episode in
                    EpisodesDetail(episodes: episode)
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            getEpisodesData(from: 1)
                        } label: {
                            Label("Baixar Dados", systemImage: "icloud.and.arrow.down")
                        }
                    }
                }
            }
        }
    }
    
    private func getEpisodesData(from id: Int) {
        Task {
            for i in id...20 {
                do {
                    let fetchedSimpsonsEpisodes = try await fetcher.fetchSimpsonsEpisodes(i)
                    
                    modelContext.insert(fetchedSimpsonsEpisodes)
                } catch {
                    print("Erro ao baixar ID \(i): \(error)")
                }
            }
            try modelContext.save()
            storeEpisodesImage()
        }
    }
    
    
    private func storeEpisodesImage() {
        Task {
            do {
                // "characters" @Query que traz os dados do SwiftData
                for episode in episodes {
                    // Só baixa se a imagem ainda não estiver salva e se houver URL
                    if episode.imageEpisodeData == nil, let urlString = episode.imageURL, let url = URL(string: urlString) {
                        
                        // Baixa os bytes da imagem
                        let (data, _) = try await URLSession.shared.data(from: url)
                        
                        // Salva os bytes no modelo
                        episode.imageEpisodeData = data
                        
                        // Salva o progresso no banco
                        try modelContext.save()
                        
                        await MainActor.run {
                            currentProgress = episode.id
                            print("📸 Imagem salva: \(episode.id) \(episode.name)")
                        }
                    }
                }
                //                await MainActor.run { isDownloading = false }
            } catch {
                print("Erro ao salvar imagens: \(error)")
                //                await MainActor.run { isDownloading = false }
            }
        }
    }
}

#Preview {
    Episodes()
        .modelContainer(for: SimpsonsEpisodes.self, inMemory: true)
}





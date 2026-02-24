//
//  Location.swift
//  SimpsonsApp
//
//  Created by Mario Duarte on 21/02/26.
//

import SwiftUI
import SwiftData

struct Location: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \SimpsonsLocations.id) private var locations: [SimpsonsLocations]
    
    let fetcher = FetchService()
    
    @State private var selectedUse: String = "All"
    
    var useCategories: [String] {
        let allUses = locations.compactMap { $0.use }.filter { !$0.isEmpty }
        let sortedUniqueUses = Array(Set(allUses)).sorted()
        return ["All"] + sortedUniqueUses
    }
    
    var filteredLocations: [SimpsonsLocations] {
        if selectedUse == "All" || selectedUse.isEmpty {
            return locations
        } else {
            return locations.filter { $0.use == selectedUse }
        }
    }
    
    func colorForCategory(_ use: String?) -> Color {
        guard let use = use, !use.isEmpty else { return Color.simpsonsYellow }
        
        let palette: [Color] = [
            .orange, .green, .blue, .purple, .pink,
                .cyan, .mint, .indigo, .teal, .brown
        ]
        let index = abs(use.hashValue) % palette.count
        return palette[index]
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text("Locations")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    Image(systemName: "map.fill")
                        .padding(.horizontal, 27)
                        .imageScale(.large)
                }
                .padding(.bottom, 10)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(useCategories, id: \.self) { categoryName in
                            Button {
                                withAnimation(.spring()) {
                                    selectedUse = categoryName
                                }
                            } label: {
                                Text(categoryName.isEmpty ? "General" : categoryName)
                                    .font(.headline.bold())
                                    .foregroundStyle(selectedUse == categoryName ? Color.black : Color.simpsonsGrayHarder)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 15)
                                    .background {
                                        RoundedRectangle(cornerRadius: 25)
                                            .fill(selectedUse == categoryName ? Color.simpsonsYellow : Color.simpsonsGrayLighter)
                                    }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 10)
                
                ScrollView {
                    LazyVStack(spacing: 20) {
                        if filteredLocations.isEmpty {
                            ContentUnavailableView(
                                "No Locations",
                                systemImage: "mappin.and.ellipse",
                                description: Text("No locations found for this category.")
                            )
                        } else {
                            ForEach(filteredLocations) { location in
                                NavigationLink(value: location) {
                                    VStack(alignment: .leading, spacing: 12) {
                                        ZStack(alignment: .topLeading) {
                                            if let data = location.imageLocationData, let uiImage = UIImage(data: data) {
                                                Image(uiImage: uiImage)
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(maxWidth: .infinity)
                                                    .frame(height: 200)
                                                    .clipped()
                                                    .cornerRadius(10)
                                            } else {
                                                RoundedRectangle(cornerRadius: 10)
                                                    .fill(Color.gray.opacity(0.2))
                                                    .frame(height: 200)
                                                    .overlay { ProgressView() }
                                            }
                                            
                                            HStack(spacing: 4) {
                                                Text(location.use?.isEmpty == false ? location.use! : "General")
                                            }
                                            .font(.caption.bold())
                                            .foregroundStyle(.black)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background {
                                                RoundedRectangle(cornerRadius: 20)
                                                    .fill(colorForCategory(location.use))
                                            }
                                            .padding(10)
                                        }
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(location.name)
                                                .font(.headline)
                                                .fontWeight(.bold)
                                                .foregroundStyle(.primary)
                                            
                                            Text(location.town?.isEmpty == false ? location.town! : "Springfield")
                                                .font(.subheadline)
                                                .foregroundStyle(.secondary)
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
                        }
                    }
                    .padding(.vertical)
                }
            }
//            .toolbar {
//                ToolbarItem(placement: .topBarTrailing) {
//                    Button {
//                        getLocationsData(from: 1)
//                    } label: {
//                        Label("Baixar Dados", systemImage: "icloud.and.arrow.down")
//                    }
//                }
//            }
        }
    }
    
    private func getLocationsData(from id: Int) {
        Task {
            for i in id...20 {
                do {
                    let fetchedSimpsonsLocations = try await fetcher.fetchSimpsonsLocations(i)
                    
                    modelContext.insert(fetchedSimpsonsLocations)
                } catch {
                    print("Erro ao baixar ID \(i): \(error)")
                }
            }
            try modelContext.save()
            storeLocationsImage()
        }
        
    }
    
    private func storeLocationsImage() {
        Task {
            do {
                for location in locations {
                    if location.imageLocationData == nil,
                       let urlString = location.imageURL,
                       let url = URL(string: urlString) {
                        
                        let (data, _) = try await URLSession.shared.data(from: url)
                        location.imageLocationData = data
                        try modelContext.save()
                        
                        await MainActor.run {
                            print("📸 Imagem salva: \(location.name)")
                        }
                    }
                }
            } catch {
                print("Erro ao salvar imagens: \(error)")
            }
        }
    }
}

#Preview {
    Location()
        .modelContainer(for: SimpsonsLocations.self, inMemory: true)
}

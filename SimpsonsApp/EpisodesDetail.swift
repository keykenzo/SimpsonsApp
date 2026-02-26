//
//  EpisodesDetail.swift
//  SimpsonsApp
//
//  Created by Mario Duarte on 24/02/26.
//

import SwiftUI

struct EpisodesDetail: View {
    
    var episodes: SimpsonsEpisodes
    
    var body: some View {
        ScrollView {
            VStack {
                VStack(spacing: 0) {
                    //Episode details
                    ZStack(alignment: .topLeading) {
//                        Image("episode1")
//                            .resizable()
//                            .scaledToFill()
//                            .frame(maxWidth: .infinity)
//                            .frame(height: 200)
//                            .clipShape(RoundedRectangle(cornerRadius: 15))
//                            .padding()
                        
                        if let data = episodes.imageEpisodeData, let uiImage = UIImage(data: data) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity)
                                .frame(height: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .padding()
                        } else {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 200)
                                .overlay {
                                    ProgressView()
                                }
                        }
                        
                        
                        
                        HStack(spacing: 4) {
                            Text("SEASON \(episodes.season)")
                        }
                        .font(.subheadline.bold())
                        .foregroundStyle(.black)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.simpsonsYellow)
                                .stroke(.white, lineWidth: 2)
                        }
                        .padding()
                        .padding(.horizontal)
                        .padding(.top)
                    }
                    
                    Text(episodes.name)
                        .font(.title2.bold())
                    
                    HStack {
                        HStack(spacing: 2) {
                            Text("E\(episodes.episodeNumber)")
                            Text("S\(episodes.season)")
                        }
                        Image(systemName: "circle.fill")
                            .font(.system(size: 5))
                            .opacity(0.5)
                        Text(episodes.airdate?.isEmpty == false ? episodes.airdate! : "Unknown Air Date")
                    }
                    .font(.caption)
                    .foregroundStyle(.simpsonsGrayHarder)
                    .padding(.top, 10)
                }
                VStack(alignment: .leading) {
                    HStack(spacing: 8) {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.simpsonsYellow)
                            .frame(width: 5, height: 22)
                        Text("Synopsis")
                            .font(.headline)
                    }
                    .padding(.bottom)
                    
                    VStack {
                        Text(episodes.synopsis.isEmpty ? "No Synopsis for this episode" : episodes.synopsis)
                            .font(.subheadline)
                            .padding()
                    }
                    .background{
                        RoundedRectangle(cornerRadius: 15)
//                            .fill(Color.white)
                            .fill(Color(uiColor: .secondarySystemGroupedBackground))
                            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                    }
                }
                .padding()
            }
        }
        .navigationTitle(episodes.name.capitalized)
    }
}

#Preview {
    NavigationStack{
        EpisodesDetail(episodes: PersistenceController.previewSimpsonsEpisodes)
    }
}

//Text("\(episodes.id)")
//Text("\(episodes.airdate!)")
//Text("\(episodes.episodeNumber)")
//Text("\(episodes.season)")
//Text("\(episodes.synopsis)")
//Text("\(episodes.imageURL!)")

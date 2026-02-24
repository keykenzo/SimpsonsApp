//
//  FetchService.swift
//  SimpsonsApp
//
//  Created by Mario Duarte on 21/02/26.
//

import Foundation

@MainActor
struct FetchService {
    enum FetchError: Error {
        case badResponse
    }
    
    private let baseURL = URL(string: "https://thesimpsonsapi.com/api/characters")!
    private let baseURLEpisode = URL(string: "https://thesimpsonsapi.com/api/episodes")!
    
    func fetchSimpsons(_ id: Int) async throws -> Simpsons {
        let fetchURL = baseURL.appending(path: String(id))
        
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw FetchError.badResponse
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let simpsonsData = try decoder.decode(Simpsons.self, from: data)
        
        print("Fetched Simpsons Character \(simpsonsData.id): \(simpsonsData.name.capitalized)")
        
        return simpsonsData
    }
    
    func fetchSimpsonsEpisodes(_ id: Int) async throws -> SimpsonsEpisodes {
        let fetchURL = baseURLEpisode.appending(path: String(id))
        
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw FetchError.badResponse
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let simpsonsDataEpisodes = try decoder.decode(SimpsonsEpisodes.self, from: data)
        
        print("Fetched Simpsons Episodes \(simpsonsDataEpisodes.id): \(simpsonsDataEpisodes.name.capitalized)")
        
        return simpsonsDataEpisodes
    }
}


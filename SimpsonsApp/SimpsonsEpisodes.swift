//
//  SimpsonsEpisodes.swift
//  SimpsonsApp
//
//  Created by Mario Duarte on 23/02/26.
//

import SwiftData
import SwiftUI

@Model class SimpsonsEpisodes: Decodable {
    @Attribute(.unique) var id: Int
    var airdate: String?
    var episodeNumber: Int
    var imageURL: String?
    var name: String
    var season: Int
    var synopsis: String
    @Attribute(.externalStorage) var imageEpisodeData: Data?
    
    enum CodingKeys: String, CodingKey {
        case id, airdate, episodeNumber, name, season, synopsis
        case imagePath = "imagePath"
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.airdate = try container.decodeIfPresent(String.self, forKey: .airdate)
        self.episodeNumber = try container.decode(Int.self, forKey: .episodeNumber)
        self.name = try container.decode(String.self, forKey: .name)
        self.season = try container.decode(Int.self, forKey: .season)
        self.synopsis = try container.decode(String.self, forKey: .synopsis)
        
        self.name = try container.decode(String.self, forKey: .name)
        
        if let path = try container.decodeIfPresent(String.self, forKey: .imagePath) {
            self.imageURL = "https://cdn.thesimpsonsapi.com/500\(String(describing: path))"
        }
    }
}


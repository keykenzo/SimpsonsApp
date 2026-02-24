//
//  SimpsonsLocations.swift
//  SimpsonsApp
//
//  Created by Mario Duarte on 24/02/26.
//

import SwiftData
import SwiftUI

@Model class SimpsonsLocations: Decodable {
    @Attribute(.unique) var id: Int
    var name: String
    var imageURL: String?
    var town: String?
    var use: String?
    @Attribute(.externalStorage) var imageLocationData: Data?
    
    enum CodingKeys: String, CodingKey {
        case id, name, town, use
        case imagePath = "imagePath"
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.town = try container.decodeIfPresent(String.self, forKey: .town)
        self.use = try container.decodeIfPresent(String.self, forKey: .use)
        
        if let path = try container.decodeIfPresent(String.self, forKey: .imagePath) {
            self.imageURL = "https://cdn.thesimpsonsapi.com/500\(String(describing: path))"
        }
    }
}


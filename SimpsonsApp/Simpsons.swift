//
//  Simpsons.swift
//  SimpsonsApp
//
//  Created by Mario Duarte on 21/02/26.
//

import SwiftData
import SwiftUI

import SwiftData
import SwiftUI

@Model class Simpsons: Decodable {
    @Attribute(.unique) var id: Int
    var name: String
    var age: Int?  //nem todos os dados tem idade
    var birthdate: String?
    var gender: String
    var occupation: String
    var phrases: [String] //nem todos os personagens tem frases -> []
    var status: String
    var imageURL: String?
    @Attribute(.externalStorage) var imageData: Data?
    
    enum CodingKeys: String, CodingKey {
        case id, name, age, birthdate, gender, occupation, phrases, status
        case portraitPath = "portraitPath"
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.age = try container.decodeIfPresent(Int.self, forKey: .age)
        self.birthdate = try container.decodeIfPresent(String.self, forKey: .birthdate)
        self.gender = try container.decode(String.self, forKey: .gender)
        self.occupation = try container.decode(String.self, forKey: .occupation)
        self.phrases = try container.decodeIfPresent([String].self, forKey: .phrases) ?? []
        self.status = try container.decode(String.self, forKey: .status)
        
        if let path = try container.decodeIfPresent(String.self, forKey: .portraitPath) {
            self.imageURL = "https://cdn.thesimpsonsapi.com/500\(String(describing: path))"
        }
    }
}




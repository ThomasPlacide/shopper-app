//
//  followings.swift
//  shopper-app
//
//  Created by Thomas Placide on 15/12/2024.
//

import Foundation

struct Following: Identifiable, Codable {
    var id: UUID
    var name: String
    var handle: String // IG handle or apple sign-in
    var spots: [Spot]

    struct Spot: Identifiable, Codable {
        enum Grade: String, Codable, CaseIterable {
            case shit = "Shit"
            case cool = "Cool"
            case must = "Must"
        }
        var id: UUID
        var name: String
        var latitude: Double
        var longitude: Double
        var grade: Grade
        var comment: String

        private enum CodingKeys: String, CodingKey {
            case id, name, latitude, longitude, grade, comment
        }

        init(id: UUID = UUID(), name: String, latitude: Double, longitude: Double, grade: Grade, comment: String) {
            self.id = id
            self.name = name
            self.latitude = latitude
            self.longitude = longitude
            self.grade = grade
            self.comment = comment
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
            self.name = try container.decode(String.self, forKey: .name)
            self.latitude = try container.decode(Double.self, forKey: .latitude)
            self.longitude = try container.decode(Double.self, forKey: .longitude)
            self.grade = try container.decode(Grade.self, forKey: .grade)
            self.comment = try container.decode(String.self, forKey: .comment)
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(id, forKey: .id)
            try container.encode(name, forKey: .name)
            try container.encode(latitude, forKey: .latitude)
            try container.encode(longitude, forKey: .longitude)
            try container.encode(grade, forKey: .grade)
            try container.encode(comment, forKey: .comment)
        }
    }

    private enum CodingKeys: String, CodingKey {
        case id, name, handle, spots
    }

    init(id: UUID = UUID(), name: String, handle: String, spots: [Spot]) {
        self.id = id
        self.name = name
        self.handle = handle
        self.spots = spots
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        self.name = try container.decode(String.self, forKey: .name)
        self.handle = try container.decode(String.self, forKey: .handle)
        self.spots = try container.decode([Spot].self, forKey: .spots)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(handle, forKey: .handle)
        try container.encode(spots, forKey: .spots)
    }
}

let followingsTestData: [Following] = {
    guard let url = Bundle.main.url(forResource: "followings", withExtension: "json") else {
        print("followings.json not found in bundle")
        return []
    }
    do {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let followings = try decoder.decode([Following].self, from: data)
        return followings
    } catch {
        print("Failed to decode followings.json: \(error)")
        return []
    }
}()

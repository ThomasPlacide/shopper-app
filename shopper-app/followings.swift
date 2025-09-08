//
//  followings.swift
//  shopper-app
//
//  Created by Thomas Placide on 15/12/2024.
//

import Foundation

struct Following: Identifiable {
    var id = UUID()
    var name: String
    var handle: String // IG handle
    // var spots: // define a spots struct containing coordinates in order to display them on the map
    
}

let followingsTestData: [Following] = [
    Following(name: "Thomas Placide", handle: "@thomasplacide"),
    Following(name: "Thierry Placide", handle: "@thierryplacide"),
    Following(name: "Julien Placide", handle: "@julienplacide"),
]

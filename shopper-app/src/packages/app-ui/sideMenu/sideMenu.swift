//
//  sideMenu.swift
//  shopper-app
//
//  Created by Thomas Placide on 15/12/2024.
//

import Foundation
import SwiftUI


struct sideMenu: View {
    var followings: [Following]
    @State private var searchText = ""

    var filteredFollowings: [Following] {
        if searchText.isEmpty {
            return followings
        } else {
            return followings.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            SearchBar(text: $searchText)
                .padding(.vertical, 8)
            List(filteredFollowings) { following in
                Text(following.name)
            }
        }
        .navigationTitle("Followings")
    }
}

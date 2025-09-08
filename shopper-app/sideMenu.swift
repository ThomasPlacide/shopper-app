//
//  sideMenu.swift
//  shopper-app
//
//  Created by Thomas Placide on 15/12/2024.
//

import Foundation
import SwiftUI

struct SearchBar: UIViewRepresentable {
    @Binding var text: String

    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String

        init(text: Binding<String>) {
            _text = text
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text)
    }

    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: Context) {
        uiView.text = text
    }
}

struct sideMenu: View {
    var followings: [Following]
        @State private var searchText = ""
        
        var filteredFollowings: [Following] {
            if searchText.isEmpty {
                return followings
            } else {
                return followings.filter { $0.name.contains(searchText) }
            }
        }
    

    var body: some View {
            VStack {
                SearchBar(text: $searchText)
                List(followings) { following in
                    Text(following.name)
                }
                Spacer()
            }

        }
    }

//
//  ContentView.swift
//  shopper-app
//
//  Created by Thomas Placide on 12/12/2024.
//

import SwiftUI
import MapKit

struct ContentView: View {
    var body: some View {
        Map().mapStyle(.standard(elevation: .realistic, showsTraffic: false))
    }
}

#Preview {
    ContentView()
}

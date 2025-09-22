//
//  ContentView.swift
//  shopper-app
//
//  Created by Thomas Placide on 12/12/2024.
//

import SwiftUI
import MapKit


struct ContentView: View {
    @State private var sideMenuButton: Bool = false
    @State private var position: MapCameraPosition = .automatic
    
    let backgroundGradient = LinearGradient(
        colors: [Color.red, Color.blue],
        startPoint: .top, endPoint: .bottom)
    
    var body: some View {
        
        GeometryReader { geometry in
            ZStack {
                Map(position: $position){
                    ForEach(followingsTestData.indices, id: \.self) { index in
                        let following = followingsTestData[index]
                        Marker("Following", coordinate: following.spots)
                    }

                }
                .mapStyle(.standard(elevation: .realistic))

                let sideMenuSize = 2*geometry.size.width / 3
                
                Button(action: {                                    withAnimation {
                    sideMenuButton.toggle()
                }
                }) {
                    Image(systemName: "list.dash")
                }
                .font(.title)
                .padding(.leading, 2.0)
                .accentColor(.black)
                .position(x: sideMenuButton ? sideMenuSize + 50 : 50, y: 45)
                if sideMenuButton {
                    Color.black.opacity(0.5)
                        .ignoresSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                sideMenuButton.toggle()
                            }
                        }
                    backgroundGradient
                        .ignoresSafeArea(.all)
                        .frame(width: sideMenuSize)

                    sideMenu(followings: followingsTestData)
                        .frame(width: sideMenuSize, height: .infinity)
                        .shadow(radius: 5)
                        .transition(.slide)
                        
                }
                
            }
        }
        
    }
}

#Preview {
    ContentView()
}

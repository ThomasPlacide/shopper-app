//
//  ContentView.swift
//  shopper-app
//
//  Created by Thomas Placide on 12/12/2024.
//

import SwiftUI
import MapKit


struct ContentView: View {
    @State private var progress: CGFloat = 0
    @State private var sideMenuButton: Bool = false
    @State private var position: MapCameraPosition = .automatic
    
    
    var body: some View {
        
        GeometryReader { geometry in
            ZStack {
                Rectangle()
                    .foregroundStyle(.clear)
                    .background {
                        Image("BG")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .contentShape(.rect)
                            .onTapGesture {
                                withAnimation(.bouncy(duration:0.75, extraBounce: 0.02)) {
                                    progress = 0
                                }
                            }
                    }
                // If following selected, display selection
                Map(position: $position) {
                    ForEach(followingsTestData) { following in
                        ForEach(following.spots) { spot in
                            Marker(spot.name, coordinate: spot.coordinates)
                            // Display only 50 or 100 locations to not overload app if a lot of spots are to be displayed (Smart filtering to randomize spots + refinement when zooming
                        }
                    }
                }
                .mapStyle(.standard(elevation: .realistic))
                    .overlay {
                        Group {
                            if #available(iOS 26.0, *) {
                                ExpandableGlassMenu(alignement: .topLeading, progress: progress){
                                    GlassFollowingListView(items: followingsTestData, title: { $0.name }) { _ in
                                        withAnimation(.bouncy(duration: 0.75, extraBounce: 0.02)) {
                                            progress = 0
                                        }
                                    }
                                } label: {
                                    Image(systemName: "list.dash")
                                        .font(.title3)
                                        .frame(width: 55, height: 55)
                                        .contentShape(.rect)
                                        .onTapGesture {
                                            withAnimation(.bouncy(duration:0.75, extraBounce: 0.02)) {
                                                progress = 1
                                            }
                                        }
                                }
                            } else {
                                Image(systemName: "list.dash")
                                    .font(.title3)
                                    .frame(width: 55, height: 55)
                                    .contentShape(.rect)
                            }
                        }
                        .frame(
                            maxWidth: .infinity,
                            maxHeight: .infinity,
                            alignment: .topLeading
                        )
                    }
            }
        }
    }
}


@available(iOS 26.0, *)
struct ExpandableGlassMenu<FollowingList: View, Label: View>: View, Animatable {
    var alignement: Alignment
    var sideMenuButtonSize: CGSize = .init(width: 50, height: 50)
    var cornerRadius: CGFloat = 30
    var progress: CGFloat
    var expandedSize: CGSize = .init(width: 300, height: 520)

    @ViewBuilder var followingList: () -> FollowingList
    @ViewBuilder var label: () -> Label

    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }
    
    var body: some View {
        GlassEffectContainer() {
            let width  = sideMenuButtonSize.width  + (expandedSize.width  - sideMenuButtonSize.width)  * contentOpacity
            let height = sideMenuButtonSize.height + (expandedSize.height - sideMenuButtonSize.height) * contentOpacity

            ZStack(alignment: alignement) {
                followingList()
                    .compositingGroup()
                    .blur(radius: 10 * blurProgress)
                    .opacity(contentOpacity)
                    .scrollContentBackground(.hidden)
                    .listStyle(.plain)
                    .listRowBackground(Color.clear)
                    .background(Color.clear)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignement)
                    .frame(width: width, height: height, alignment: alignement)

                label()
                    .compositingGroup()
                    .blur(radius: 10 * blurProgress)
                    .opacity(1 - labelOpacity)
                    .frame(width: sideMenuButtonSize.width,
                           height: sideMenuButtonSize.height)
            }
            .compositingGroup()
            .clipShape(.rect(cornerRadius: cornerRadius))
            .glassEffect(.regular.interactive(), in: .rect(cornerRadius: cornerRadius))
        }
        .scaleEffect(
            x: 1 - (blurProgress * 0.35),
            y: 1 - (blurProgress * 0.45),
            anchor: scaleAnchor
        )
        .offset(y: offsetAdjustment * blurProgress)
    }

    var labelOpacity: CGFloat {
        min(progress / 0.35, 1)
    }

    var contentOpacity: CGFloat{
        max(progress - 0.35, 0) /  0.85
    }

    var blurProgress: CGFloat {
        let p = min(max(progress, 0), 1)
        return p > 0.5 ? (1 - p) / 0.5 : p / 0.5
    }

    var offsetAdjustment: CGFloat {
        switch alignement {
        case .bottom, .bottomLeading, .bottomTrailing: return -75
        case .top, .topLeading, .topTrailing: return 75
        default: return 0
        }
    }
    var scaleAnchor: UnitPoint {
        switch alignement{
        case .bottomLeading: return .bottomLeading
        case .bottom: return .bottom
        case .bottomTrailing: return .bottomTrailing
        case .topLeading: return .topLeading
        case .top: return .top
        case .topTrailing: return .topTrailing
        case .leading: return .leading
        case .trailing: return .trailing
        default: return .center
        }
    }
}
@available(iOS 26.0, *)
struct GlassFollowingListView<Item: Identifiable>: View {
    let items: [Item]
    let title: (Item) -> String
    var onTap: (Item) -> Void = { _ in }

    var body: some View {
        ScrollView {
            GlassEffectContainer(spacing: 12) {
                LazyVStack(spacing: 12) {
                    ForEach(items) { item in
                        Button(action: { onTap(item) }) {
                            HStack(spacing: 12) {
                                Text(title(item))
                                    .font(.headline)
                                    .foregroundStyle(.primary)
                                Spacer()
                            }
                            .padding(16)
                            .contentShape(.rect)
                        }
                        .buttonStyle(.plain)
                        .frame(maxWidth: .infinity)
                        .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 16))
                    }
                }
                .padding(.vertical, 8)
            }
            .padding(.horizontal, 12)
        }
        .scrollIndicators(.hidden)
        .background(Color.clear)
    }
}


#Preview {
    ContentView()
}


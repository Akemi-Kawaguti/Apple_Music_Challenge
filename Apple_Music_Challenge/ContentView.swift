//
//  ContentView.swift
//  Apple_Music_Challenge
//
//  Created by Tais Akemi Kawaguti on 21/07/26.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showFullScreenPlayer = false
    
    var body: some View {
        
        TabView {
            Tab("Home", systemImage: "house.fill") {
                HomeView()
                    .safeAreaPadding(.top, 80)
            }
            Tab("Match", systemImage: "person.crop.circle.fill") {
                Match()
                    .safeAreaPadding(.top, 80)
            }
            Tab("Amigos", systemImage: "play.square.stack.fill") {
                Amigos()
                    .safeAreaPadding(.top, 80)
            }
            
            Tab (role: .search) {
                // Só pra ir testando a view de musica enquanto nn decidimos um jeito de ir ver ela.
            }
        }
        .overlay(alignment: .top) {
            MiniPlayerView(expandPlayer: $showFullScreenPlayer)
        }
        .fullScreenCover(isPresented: $showFullScreenPlayer) {
            MusicView(expandPlayer: $showFullScreenPlayer)
        }
        
    }
}

#Preview {
    ContentView()
}

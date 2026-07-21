//
//  ContentView.swift
//  Apple_Music_Challenge
//
//  Created by Tais Akemi Kawaguti on 21/07/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house.fill") {
                HomeView()
            }
            Tab("Profile", systemImage: "person.crop.circle.fill") {
//                PerfilView()
            }
            Tab("Discover", systemImage: "play.square.stack.fill") {
//                DescobrirView()
            }
            
            Tab (role: .search) {
                // Só pra ir testando a view de musica enquanto nn decidimos um jeito de ir ver ela.
                MusicView()
            }
        }
    }
}

#Preview {
    ContentView()
}

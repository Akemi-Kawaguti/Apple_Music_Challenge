//
//  HomeView.swift
//  Apple_Music_Challenge
//
//  Created by João on 21/07/26.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Text("Mais Ouvidas")
                        .font(.headline)
                    Spacer()
                }
                // Genial o uso da LazyHStack!!!
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack {
                        ForEach(1..<10) { num in
                            CardMusica(imagem: "Musica_" + String(num))
                        }
                    }
                }
            }
            .padding()
            // ISSO AQUI TEM Q SER DINAMICADO!!!!!!!!
            .padding(.horizontal, 15)
            
            // https://developer.apple.com/documentation/swiftui/grid
            Grid(alignment: .center, horizontalSpacing: 75, verticalSpacing: 20) {
                GridRow {
                    CardServicos(imagem: "podcast", servico: "Podcast ao vivo")
                    CardServicos(imagem: "Musica_1", servico: "Novidades")
                    
                }
                
                GridRow {
                    CardServicos(imagem: "amigos", servico: "Amigos ouvindo")
                    CardServicos(imagem: "festival", servico: "Marcar evento")
                }
            }
            .padding()
            
            VStack {
                HStack {
                    Text("Suas Playlists")
                        .font(.headline)
                    Spacer()
                }
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(1..<10) { num in
                            CardMusica(imagem: "Musica_" + String(num))
                        }
                    }
                }
            }
            .padding()
            // ISSO AQUI TEM Q SER DINAMICADO!!!!!!!!
            .padding(.horizontal, 15)
            Spacer()
        }
    }
}

#Preview {
    HomeView()
}

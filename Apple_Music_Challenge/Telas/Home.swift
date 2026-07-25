//
//  Home.swift
//  Apple_Music_Challenge
//
//  Created by Tais Akemi Kawaguti on 21/07/26.
//

import SwiftUI

struct Home: View {
    var body: some View {
        
        ScrollView{
            VStack{
                
                //MARK: Mais ouvidas
                HStack {
                    Text("Mais Ouvidas")
                        .font(.title2.bold())
                        .foregroundColor(Color.amarelo)
                        .padding(.horizontal)
                    Spacer()
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 15) {
                        ForEach(1...5, id: \.self) { num in
                            CardMusica(imagem: "Musica_\(num)")
                        }
                    }
                    .padding(.horizontal) //espaço entre a tela
                }
                .scrollTargetLayout()
                .frame(maxWidth: .infinity)
                
                //MARK: Serviços
                Grid (alignment: .center, horizontalSpacing: 55, verticalSpacing: 30){
                    
                    GridRow {
                        CardServicos(imagem: "podcast", servico: "Podcast ao vivo")
                        CardServicos(imagem: "Musica_1", servico: "Novidades")
                    }
                    
                    GridRow {
                        CardServicos(imagem: "amigos", servico: "Amigos ouvindo")
                        CardServicos(imagem: "festival", servico: "Marcar evento")
                    }
                }
                .padding(20) //Grid
                .padding(.vertical)
                
                //MARK: Suas playlists
                    HStack {
                        Text("Suas Playlists")
                            .font(.title2.bold())
                            .foregroundColor(Color.amarelo)
                            .padding(.horizontal)
                        Spacer()
                    }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 15) {
                        ForEach(1...5, id: \.self) { num in
                            CardMusica(imagem: "Musica_\(num)")
                        }
                    }
                    .padding(.horizontal) //espaço entre a tela
                }
                .scrollTargetLayout()
                .frame(maxWidth: .infinity)
                
            } //VStack
        } .background(Color.background) //body
    } //home view
} //Scrowview

#Preview {
    Home()
}

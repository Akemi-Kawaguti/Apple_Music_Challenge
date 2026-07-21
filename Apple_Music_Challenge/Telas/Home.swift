//
//  Home.swift
//  Apple_Music_Challenge
//
//  Created by Tais Akemi Kawaguti on 21/07/26.
//

import SwiftUI

struct Home: View {
    var body: some View {
        
        VStack{
            
            //MARK: Mais ouvidas
                            
                Text("Mais ouvidas")
                    .font(Font.custom("SF Pro", size: 18))
                    .foregroundColor(Color.amarelo)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 15) {
                        CardMusica(imagem: "Musica_1")
                        CardMusica(imagem: "Musica_2")
                        CardMusica(imagem: "Musica_3")
                        CardMusica(imagem: "Musica_4")
                        CardMusica(imagem: "Musica_5")
                        
                    }
                    .padding(.horizontal, 30) //espaço entre a tela
                }
                .scrollTargetLayout()
                .frame(maxWidth: .infinity)
            
            //MARK: Serviços
            
            Grid {
                GridRow {
                    HStack (spacing:50){
                        CardServicos(imagem: "podcast", servico: "Podcast ao vivo")
                        CardServicos(imagem: "Musica_1", servico: "Novidades")
                    }
                }
                //GridRow
                GridRow {
                    HStack (spacing:50){
                        CardServicos(imagem: "amigos", servico: "Amigos ouvindo")
                        CardServicos(imagem: "festival", servico: "Marcar evento")
                    }
                }
                .padding(30)
            } //Grid
            
            //MARK: Suas playlists
                            
                Text("Suas playlists")
                    .font(Font.custom("SF Pro", size: 18))
                    .foregroundColor(Color.amarelo)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 15) {
                        CardMusica(imagem: "Musica_1")
                        CardMusica(imagem: "Musica_2")
                        CardMusica(imagem: "Musica_3")
                        CardMusica(imagem: "Musica_4")
                        CardMusica(imagem: "Musica_5")
                        
                    }
                    .padding(.horizontal, 30) //espaço entre a tela
                }
                .scrollTargetLayout()
                .frame(maxWidth: .infinity)
            
            
        } //VStack
        .background(Color.background)
    } //body
} //home view


#Preview {
    Home()
}

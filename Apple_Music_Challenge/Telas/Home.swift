//
//  Home.swift
//  Apple_Music_Challenge
//
//  Created by Tais Akemi Kawaguti on 21/07/26.
//

import SwiftUI
//import Kingfisher

struct Home: View {
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack(spacing: 20){
                    //playlists
//                    PlayListView()
                    //todas musicas
                    //albuns
                    
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
}
#Preview {
    Home()
}

//struct PlayListView: View{
//    var body: some View{
//        VStack{
//            //titulo
//            HStack(spacing: 7){
//                Text("Playlist")
//                    .font(.title2)
//                    .fontWeight(.semibold)
//                Image(systemName: "chevron.right")
//                    .padding(.top, 2)
//                    .fontWeight(.semibold)
//                    .foregroundStyle(.black.opacity(0.5))
//                Spacer()
//            }.padding(.horizontal)
//            //scroll
//            ScrollView(.horizontal, showsIndicators: false){
//                LazyHStack(spacing: 14){
//                    ForEach(0..<5){ musica in
//                        MusicRowView(music: musica)
//                    }
//                }
//            }
//        }
//    }
//}

//struct MusicRowView: View{
//    var music: Musicas
//    var width, height: CGFloat?
//    var body: some View{
//        VStack(alignment: .leading){
//            Image("music")
//                .resizable()
//                .scaledToFit()
//                .frame(width: width ?? 160, height: height ?? 160)
//                .clipShape(
//                    UnevenRoundedRectangle(
//                        topLeadingRadius: 5,
//                        bottomLeadingRadius: 15,
//                        bottomTrailingRadius: 5,
//                        topTrailingRadius: 15
//                    )
//                )
//            VStack(alignment: .leading, spacing: 0){
//                Text(music.name)
//                    .font(.headline)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .lineLimit(1)
//                    .foregroundStyle(.black)
//                Text(music.artist)
//                    .font(.subheadline)
//                    .lineLimit(1)
//                    .foregroundStyle(.black.opacity(0.7))
//            }
//        }.frame(width: width ?? 160)
//    }
//}

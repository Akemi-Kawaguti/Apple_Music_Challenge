//
//  Evento.swift
//  Apple_Music_Challenge
//
//  Created by Tais Akemi Kawaguti on 25/07/26.
//

import SwiftUI

struct Evento: View {
    
    var body: some View {
        
        ZStack{
            LinearGradient(
                stops: [
                    .init(color: .yellow, location: 0),
                    .init(color: .orange, location: 0.35),
                    .init(color: .background, location: 0.7)
                ],
                startPoint: .top,
                endPoint: .center
            )
            .ignoresSafeArea()
            
            ScrollView{
                VStack{
                    
                    HStack{
                        
                        Image("amigos")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 54, height: 54)
                            .clipShape(Circle())
                        
                        Text("Eventos - Hoje é o grande dia:")
                            .font(.subheadline)
                            .foregroundStyle(.white) //arrumar dark mode
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 40))
                    }
                    .background(.black) //arrumar dark mode
                    .cornerRadius(50)
                    .padding(.vertical)
                    
                    //MARK: Banner Evento
                    Image("Banner_Evento")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 365, height: 189, alignment: .leading)
                        .clipShape(
                            UnevenRoundedRectangle(
                                topLeadingRadius: 5,
                                bottomLeadingRadius: 15,
                                bottomTrailingRadius: 5,
                                topTrailingRadius: 15
                            )
                        )/*.stroke(.white.opacity(0.5), lineWidth: 0.2)*/.padding(.vertical)
                    
                    //MARK: Sugestões
                    HStack {
                        Text("Sugestões")
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
                    Spacer()
                        .padding(.vertical)
                    
                    //MARK: Seus amigos ouviram nesse dia
                    HStack {
                        Text("Seus amigos ouviram nesse dia")
                            .font(.title2.bold())
                            .foregroundColor(Color.amarelo)
                            .padding(.horizontal)
                        Spacer()
                    }
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 15) {
                            ForEach(1...5, id: \.self) { num in
                                DiscoAmigo(imagem: "Musica_\(num)")
                            }
                        }
                        .padding(.horizontal) //espaço entre a tela
                    }
                    .scrollTargetLayout()
                    .frame(maxWidth: .infinity)
                    
                } //VStack
                
            } //body
        } //home view
    } //Scrowview
}

#Preview {
    Evento()
}

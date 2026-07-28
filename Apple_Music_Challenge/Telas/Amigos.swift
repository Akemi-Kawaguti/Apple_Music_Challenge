//
//  Amigos.swift
//  Apple_Music_Challenge
//
//  Created by Tais Akemi Kawaguti on 25/07/26.
//

import SwiftUI

struct Amigos: View {
    
    private let generos = ["Rock", "Eletronica"]
    
    var body: some View {
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack(alignment: .leading, spacing: 24) {
                    
                    // MARK: Cabeçalho
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Explorar")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Text("O que estão ouvindo")
                            .font(.title)
                            .bold()
                            .foregroundColor(.primary)
                    }
                    .padding(.horizontal)
                    
                    // MARK: Amigos Ouvindo
                    VStack(spacing: 15) {
                        ForEach(1...4, id: \.self) { num in
                            AmigoOuvindo(imagem: "Musica_\(num)", titulo: "Inabalavel", amigo: "Akeminha")
                        }
                    }
                    .padding(.horizontal)
                    
                    // MARK: Seções de Estilo Musical
                    ForEach(generos, id: \.self) { genero in
                        SecaoMusical(titulo: genero)
                    }
                    
                }
                .padding()
            }
            .background(
                LinearGradient(
                    stops: [
                        .init(color: .pink, location: 0),
                        .init(color: .purple, location: 0.35),
                        .init(color: .background, location: 0.7)
                    ],
                    startPoint: .top,
                    endPoint: .center
                )
                .ignoresSafeArea()
            )
            //            .background(Color.background)
    }
}

#Preview {
    Amigos()
}

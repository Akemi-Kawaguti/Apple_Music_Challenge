//
//  MiniPlayer.swift
//  Apple_Music_Challenge
//
//  Created by João Duque Nardelli Wandermuren on 28/07/26.
//

import SwiftUI

struct MiniPlayerView: View {
    @Binding var expandPlayer: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            // Utilizar placeholder da api spotify
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 33, height: 33)
                .overlay {
                    Image(systemName: "music.note")
                        .foregroundColor(.gray)
                }
            
            // Colocar nome e autor pelo spotify
            VStack(alignment: .leading) {
                Text("SwiftUI Symphony")
                    .font(.footnote)
                    .bold()
                Text("SwiftUI Symphony")
                    .font(.caption)
                    .bold()
            }
            
            Spacer()
            
            // Controles
            Button(action: { /* Colocar função do spotify aqui */ }) {
                Image(systemName: "backward.fill")
                    .font(.title2)
                    .foregroundColor(.primary)
            }
            
            Button(action: { /* Colocar função do spotify aqui */ }) {
                Image(systemName: "play.fill")
                    .font(.title2)
                    .foregroundColor(.primary)
            }
//            .padding(.horizontal, 8)
            
            Button(action: { /* Colocar função do spotify aqui */ }) {
                Image(systemName: "forward.fill")
                    .font(.title2)
                    .foregroundColor(.primary)
            }
        }
        .padding(8)
        .padding(.trailing, 10)
        .padding(.horizontal, 10)
        
        // dar forma
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 50))
        .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
        
        // Pra ficar no meio
        .padding(.horizontal)
        
        // não ficar em cima
        .padding(.top, 10)
        
        .onTapGesture {
            expandPlayer = true
        }
    }
}

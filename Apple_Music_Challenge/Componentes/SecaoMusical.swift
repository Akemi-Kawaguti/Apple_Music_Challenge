//
//  SecaoMusical.swift
//  Apple_Music_Challenge
//
//  Created by João Duque Nardelli Wandermuren on 28/07/26.
//

import Foundation
import SwiftUI

// MARK: - Componente de Seção Horizontal Reaproveitável
struct SecaoMusical: View {
    let titulo: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(titulo)
                .font(.title2)
                .bold()
                .foregroundColor(.amarelo)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 15) {
                    ForEach(1...5, id: \.self) { num in
                        CardMusica(imagem: "Musica_\(num)")
                    }
                }
                .padding(.horizontal)
            }
            .scrollTargetLayout()
        }
    }
}

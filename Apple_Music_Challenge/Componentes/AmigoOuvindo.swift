//
//  AmigoOuvindo.swift
//  Apple_Music_Challenge
//
//  Created by Tais Akemi Kawaguti on 24/07/26.
//

import SwiftUI

struct AmigoOuvindo: View {
    let imagem: String
    let titulo: String
    let amigo: String
    
    var body: some View {
        
        HStack{
            
            VStack{
                Image(imagem)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 45, height: 45)
                    .clipShape(Circle())
            }.padding(.horizontal, 15)
            
            VStack(alignment: .leading, spacing: 7) {
                Text(titulo)
                    .font(.title3)
                    .bold()
                
                Text(amigo)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }.padding(.vertical, 15)
            
            Spacer()
            
        }.background(.gray.opacity(0.3))
            .clipShape(
                UnevenRoundedRectangle(
                    topLeadingRadius: 5,
                    bottomLeadingRadius: 15,
                    bottomTrailingRadius: 5,
                    topTrailingRadius: 15
                ))
            .padding(.horizontal, 15)
    } //body view
} //card view

#Preview {
    AmigoOuvindo(imagem: "", titulo: "", amigo: "")
}

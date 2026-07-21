//
//  CardServicos.swift
//  Apple_Music_Challenge
//
//  Created by Tais Akemi Kawaguti on 21/07/26.
//

import SwiftUI

struct CardServicos: View {
    let imagem: String
    let servico: String
    
    let shape = UnevenRoundedRectangle(
        topLeadingRadius: 15,
        bottomLeadingRadius: 1,
        bottomTrailingRadius: 15,
        topTrailingRadius: 1
    )
    
    var body: some View {
        
        VStack(spacing: 18) {
            Text(servico)
            
            shape
                .fill(.clear)
                .frame(width: 127, height: 127)
                .overlay {
                    
                    Image(imagem)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 117, height: 117)
                        .clipShape(shape)
                }
                .overlay {
                    shape.stroke(Color(red: 0.47, green: 0.47, blue: 0.47).opacity(0.2), lineWidth: 10)
                }
            
        } //VStack 18
    } //body view
} //card view

#Preview {
    CardServicos(imagem: "", servico: "")
}

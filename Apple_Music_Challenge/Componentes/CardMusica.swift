//
//  CardMusica.swift
//  Apple_Music_Challenge
//
//  Created by Tais Akemi Kawaguti on 21/07/26.
//

import SwiftUI

struct CardMusica: View {
    let imagem: String
    
    //    let imagePlaceholderColor = Color(red: 0.50, green: 0.23, blue: 0.27).opacity(0.50)
    
    var body: some View {
        
        Image(imagem)
            .resizable()
            .scaledToFill()
            .frame(width: 95, height: 95)
            .clipShape(
                UnevenRoundedRectangle(
                    topLeadingRadius: 5,
                    bottomLeadingRadius: 15,
                    bottomTrailingRadius: 5,
                    topTrailingRadius: 15
                )
            )
        
    } //body view
} //card view

#Preview {
    CardMusica(imagem: "")
}

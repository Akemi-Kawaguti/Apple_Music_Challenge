//
//  DiscoAmigo.swift
//  Apple_Music_Challenge
//
//  Created by Tais Akemi Kawaguti on 24/07/26.
//

import SwiftUI

struct CentroDisco: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(.black)
                .frame(width: 20)
                .overlay {
                    Circle()
                        .stroke(.white.opacity(0.4), lineWidth: 0.8)
                }
            
            Circle()
                .fill(.black)
                .frame(width: 10)
                .overlay {
                    Circle()
                        .stroke(.white.opacity(0.4), lineWidth: 0.8)
                }
        }
    } //body
} //CentroDisco

struct DiscoAmigo: View {
    
    let imagem: String
    private let cardSize: CGFloat = 90
    private let discoSize: CGFloat = 90
    
    var body: some View {
        
        Rectangle()
            .fill(.clear)
            .background(.gray)
            .frame(width: 100, height: 100)
            .overlay {
                
                Image(imagem)
                    .resizable()
                    .scaledToFill()
                    .frame(width: discoSize, height: discoSize)
                    .clipShape(Circle())
                EllipticalGradient(
                    colors: [
                        .white.opacity(0.2),
                        .black.opacity(0.2),
                        .gray.opacity(0.2),
                        .black.opacity(0.2),
                        .white.opacity(0.2)
                    ], center: .center
                )
                
                .overlay {
                    CentroDisco()
                }
            }.cornerRadius(10)
        
    } //body view
} //card view

#Preview {
    DiscoAmigo(imagem: "")
}

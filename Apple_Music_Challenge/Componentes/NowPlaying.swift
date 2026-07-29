//
//  NowPlayingHeaderView.swift
//  Apple_Music_Challenge
//
//  Created by Tais Akemi Kawaguti on 29/07/26.
//

import SwiftUI

struct NowPlaying: View {

    @State private var spotifyManager = SpotifyManager()

    var imageSize: CGFloat = 250
    var showArtworkOnly: Bool = false
    
    var body: some View {
        VStack(spacing: 16) {
            // Capa do Álbum Dinâmica
            Group {
                if let artworkURL = spotifyManager.currentSong?.albumArtworkURL,
                   let url = URL(string: artworkURL) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(width: imageSize, height: imageSize)
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .clipShape(
                                    UnevenRoundedRectangle(
                                        topLeadingRadius: 10,
                                        bottomLeadingRadius: 30,
                                        bottomTrailingRadius: 10,
                                        topTrailingRadius: 30
                                    )
                                )
                                .shadow(radius: 10)
                            
                        case .failure(_):
                            placeholderImage
                        @unknown default:
                            placeholderImage
                        }
                    }
                } else {
                    placeholderImage
                }
            }
            .frame(width: imageSize, height: imageSize)
            .frame(alignment: .center)
            .cornerRadius(12)
            .shadow(radius: 8)
            
            // Título e Artista (Ocultável se quiser apenas a imagem)
            if !showArtworkOnly {
                VStack(spacing: 4) {
                    Text(spotifyManager.currentSong?.title ?? "Nenhuma música tocando")
                        .font(.title3)
                        .bold()
                        .lineLimit(1)
                        .foregroundColor(.primary)
                    
                    Text(spotifyManager.currentSong?.artistName ?? "Spotify")
                        .font(.subheadline)
                        .lineLimit(1)
                        .foregroundColor(.secondary)
                }
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            }
        }
    }
    
    private var placeholderImage: some View {
        Image(systemName: "music.note")
            .resizable()
            .scaledToFit()
            .opacity(0.5)
            .frame(maxWidth: .infinity, alignment: .center)
        
    }
}

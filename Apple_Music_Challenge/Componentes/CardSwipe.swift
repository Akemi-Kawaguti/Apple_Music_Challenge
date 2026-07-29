//
//  CardSwipe.swift
//  Apple_Music_Challenge
//
//  Created by Tais Akemi Kawaguti on 28/07/26.
//

import SwiftUI

struct CardSwipe: View {
    
    @State private var audioManager = SpotifyManager()
    @State private var artworkImage: UIImage? = nil
    
    var person: String
    @State private var offSet = CGSize.zero
    @State private var colorSwipe: Color = .black
    
    var body: some View {
        VStack{
            ZStack {
                
                VStack(alignment: .leading, spacing: 20) {
                    
                    NowPlaying(imageSize: 150, showArtworkOnly: true)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .offset(x: offSet.width, y: offSet.height * 0.4)
            .rotationEffect(.degrees(Double(offSet.width / 40)))
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        offSet = gesture.translation
                        withAnimation{
                            chanceColorSwipe(width: offSet.width)
                        }
                    } .onEnded { _ in
                        withAnimation{
                            swipeCard(width: offSet.width)
                            chanceColorSwipe(width: offSet.width)
                        }
                    }
            )
            
            VStack(spacing: 10){
                Text(audioManager.currentSong?.title ?? "Nenhuma música")
                    .font(.title2)
                    .bold()
                
                Text(audioManager.currentSong?.artistName ?? "Artista")
                    .font(.subheadline)
                .foregroundStyle(.secondary)}
        }}

    
    func swipeCard(width: CGFloat) {
        switch width {
        case -500...(-150):
            print("\(person) removed")
            offSet = CGSize(width: -500, height: 0)
        case 150...500:
            print("\(person) added")
            offSet = CGSize(width: 500, height: 0)
        default :
            offSet = .zero
        }
    }
    
    func chanceColorSwipe(width: CGFloat) {
        switch width {
        case -500...(-130):
            colorSwipe = .red
            audioManager.toggleShuffle()
        case 130...500:
            colorSwipe = .green
            audioManager.toggleShuffle()
        default :
            colorSwipe = .black
        }
    }
}

#Preview {
    CardSwipe(person: "Tais")
}

//
//  CardSwipe.swift
//  Apple_Music_Challenge
//
//  Created by Tais Akemi Kawaguti on 28/07/26.
//

import SwiftUI

struct CardSwipe: View {
    
    @State private var audioManager = SpotifyManager()
    @State private var isDraggingSlider = false
    @State private var localSliderValue: Double = 0.0
    @State private var artworkImage: UIImage? = nil
    
    var person: String
    @State private var offSet = CGSize.zero
    @State private var colorSwipe: Color = .black
    
    var body: some View {
        VStack{
            ZStack {
                //                Rectangle()
                //                    .scaledToFill()
                //                    .frame(width: 257, height: 241)
                //                    .foregroundStyle(colorSwipe.opacity(0.9))
                //                    .clipShape(
                //                        UnevenRoundedRectangle(
                //                            topLeadingRadius: 5,
                //                            bottomLeadingRadius: 15,
                //                            bottomTrailingRadius: 5,
                //                            topTrailingRadius: 15
                //                        )
                //                    )
                
                VStack(alignment: .leading, spacing: 20) {
                    
                    // Exibição da capa do álbum vinda da URL da Spotify Web API
                    if let artworkURLString = audioManager.currentSong?.albumArtworkURL,
                       let url = URL(string: artworkURLString) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(width: 257, height: 241)
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(
                                        UnevenRoundedRectangle(
                                            topLeadingRadius: 10,
                                            bottomLeadingRadius: 30,
                                            bottomTrailingRadius: 10,
                                            topTrailingRadius: 30
                                        )
                                    )
                                    .task(id: url) {
                                        if let data = try? Data(contentsOf: url),
                                           let uiImage = UIImage(data: data) {
                                            self.artworkImage = uiImage
                                        }
                                    }
                            case .failure(_):
                                Image(systemName: "music.note")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 200, height: 200)
                            @unknown default:
                                EmptyView()
                            }
                        }
                    } else {
                        HStack {
                            Spacer()
                            Image(systemName: "music.note")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 200)
                            Spacer()
                        }
                    }
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
        case 130...500:
            colorSwipe = .green
        default :
            colorSwipe = .black
        }
    }
}

#Preview {
    CardSwipe(person: "Tais")
}

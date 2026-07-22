//
//  MusicView.swift
//  Music
//
//  Created by João Duque Nardelli Wandermuren on 17/07/26.
//

import SwiftUI


// Tela onde mostra a musica atual
struct MusicView: View {
    
    @State var slider: CGFloat = 25;
    @State var audioManager = AudioManager()
    
    var body: some View {
        Spacer()
        VStack(alignment: .leading) {
            Image("Musica_1")
                .resizable()
                .scaledToFit()
    //            .frame(width: 300, height: 300)
                .foregroundColor(.blue)
                .clipShape(
                    UnevenRoundedRectangle(
                        topLeadingRadius: 10,
                        bottomLeadingRadius: 30,
                        bottomTrailingRadius: 10,
                        topTrailingRadius: 30
                    )
                )
                .padding(.bottom, 20)
        
        
            Text("SwiftUI Symphony")
                .font(.title2)
                .bold()
                
            Text("Apple Dev")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Slider(value: $slider, in: 0...100)
            
            // Botões
            
            HStack {
                Button(action: {
                    if audioManager.isPlaying {
                        audioManager.pause()
                    } else {
                        audioManager.play()
                    }
                }) {
                    Image(systemName: "repeat")
                        .font(Font.system(size: 22))
                    //                        .foregroundColor(.blue)
                }
                .frame(maxWidth: .infinity)

                
                Button(action: {
                    if audioManager.isPlaying {
                        audioManager.pause()
                    } else {
                        audioManager.play()
                    }
                }) {
                    Image(systemName: "backward.end.fill")
                        .font(Font.system(size: 22))
                    //                        .foregroundColor(.blue)
                }
                .frame(maxWidth: .infinity)

                
                Button(action: {
                    if audioManager.isPlaying {
                        audioManager.pause()
                    } else {
                        audioManager.play()
                    }
                }) {
                    Image(systemName: "backward.fill")
                        .font(Font.system(size: 26))
                    //                        .foregroundColor(.blue)
                }
                .frame(maxWidth: .infinity)

                
                Button(action: {
                    if audioManager.isPlaying {
                        audioManager.pause()
                    } else {
                        audioManager.play()
                    }
                }) {
                    Image(systemName: audioManager.isPlaying ? "pause.fill" : "play.fill")
                        .font(Font.system(size: 40))
                    //                        .foregroundColor(.blue)
                }
                .frame(maxWidth: .infinity)

                
                Button(action: {
                    if audioManager.isPlaying {
                        audioManager.pause()
                    } else {
                        audioManager.play()
                    }
                }) {
                    Image(systemName: "forward.fill")
                        .font(Font.system(size: 26))
                    //                        .foregroundColor(.blue)
                }
                .frame(maxWidth: .infinity)

                
                Button(action: {
                    if audioManager.isPlaying {
                        audioManager.pause()
                    } else {
                        audioManager.play()
                    }
                }) {
                    Image(systemName: "forward.end.fill")
                        .font(Font.system(size: 22))
                    //                        .foregroundColor(.blue)
                }
                .frame(maxWidth: .infinity)

                
                Button(action: {
                    if audioManager.isPlaying {
                        audioManager.pause()
                    } else {
                        audioManager.play()
                    }
                }) {
                    Image(systemName: "airplay.audio")
                        .font(Font.system(size: 22))
                    //                        .foregroundColor(.blue)
                }
                .frame(maxWidth: .infinity)

            }
        }
        .padding()
        .padding(.horizontal, 20)
//        .border(.red, width: 1)
        
        UnevenRoundedRectangle(
            topLeadingRadius: 10,
            bottomLeadingRadius: 30,
            bottomTrailingRadius: 10,
            topTrailingRadius: 30
        )
        .padding(.horizontal, 20)
        .padding()
        .frame(maxHeight: 190)
        .foregroundStyle(.ultraThickMaterial)
//        .border(Color.gray, width: 1)
        
        // Ainda vai ter isso? vc nn implementou no protótipo que vc fez nem os SF Symbols
        .toolbar {
            Button(
                "",
                systemImage: "apple.haptics.and.music.note",
                action: {}
            )
        }
    }
}

#Preview {
    MusicView()
}

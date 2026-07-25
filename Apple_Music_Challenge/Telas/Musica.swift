//
//  Musica.swift
//  Apple_Music_Challenge
//
//  Created by Tais Akemi Kawaguti on 23/07/26.
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
                .clipShape(
                    UnevenRoundedRectangle(
                        topLeadingRadius: 10,
                        bottomLeadingRadius: 30,
                        bottomTrailingRadius: 10,
                        topTrailingRadius: 30
                    )
                )
                .padding()
        
        
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
                    Image(systemName: "repeat") //nao ta executando
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
                    Image(systemName: "backward.end.fill") //mudar para qualidade de som
                        .font(Font.system(size: 22))
//                                            .foregroundColor(.blue)
                }
                .frame(maxWidth: .infinity)

                
                Button(action: {
                    if audioManager.isPlaying {
                        audioManager.pause()
                    } else {
                        audioManager.play()
                    }
                }) {
                    Image(systemName: "backward.fill") //voltar 10 segundos
                        .font(Font.system(size: 26))
//                                            .foregroundColor(.black)
                }
                .frame(maxWidth: .infinity)

                
                Button(action: {
                    if audioManager.isPlaying {
                        audioManager.pause()
                    } else {
                        audioManager.play()
                    }
                }) {
                    Image(systemName: audioManager.isPlaying ? "pause.fill" : "play.fill") //animação mais sutil
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
                    Image(systemName: "forward.fill") //10 segundos a frente
                        .font(Font.system(size: 26))
//                                            .foregroundColor(.black)
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

                
                Button(action: {
                    if audioManager.isPlaying {
                        audioManager.pause()
                    } else {
                        audioManager.play()
                    }
                }) {
                    Image(systemName: "airplay.audio") //biblioteca
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

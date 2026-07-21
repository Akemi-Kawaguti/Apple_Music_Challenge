//
//  MusicView.swift
//  Music
//
//  Created by João Duque Nardelli Wandermuren on 17/07/26.
//

import SwiftUI


// Tela onde mostra a musica atual
struct MusicView: View {
    
    @State var audioManager = AudioManager()
    
    var body: some View {
        VStack(spacing: 30) {
                    Image(systemName: "waveform.circle.fill")
                        .resizable()
                        .frame(width: 200, height: 200)
                        .foregroundColor(.blue)
                    
                    Text("SwiftUI Symphony")
                        .font(.title)
                        .bold()
                    
                    Text("Apple Dev")
                        .font(.title3)
                        .foregroundColor(.secondary)
                    
                    Button(action: {
                        if audioManager.isPlaying {
                            audioManager.pause()
                        } else {
                            audioManager.play()
                        }
                    }) {
                        Image(systemName: audioManager.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.blue)
                    }
                }
                .padding()
        
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

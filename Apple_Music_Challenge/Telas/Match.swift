//
//  Match.swift
//  Apple_Music_Challenge
//
//  Created by Tais Akemi Kawaguti on 28/07/26.
//

import SwiftUI

struct Match: View {
    
    @State private var audioManager = SpotifyManager()
    
    @State private var isDraggingSlider = false
    @State private var localSliderValue: Double = 0.0
    @State private var artworkImage: UIImage? = nil
    
    private var people: [String] = ["Tais", "Akemi", "Kawaguti", "Allan", "Rodrigo"].reversed()
    
    var body: some View {

        
        ZStack{
            // Background
            Group {
                if let artworkImage {
                    FundoTela(image: artworkImage)
                } else {
                    LinearGradient(
                        stops: [
                            .init(color: .indigo, location: 0),
                            .init(color: .blue, location: 0.25),
                            .init(color: .background, location: 0.7)
                        ],
                        startPoint: .top,
                        endPoint: .center
                    )
                }
            } .ignoresSafeArea()

            // MARK: Cabeçalho
            VStack(alignment: .leading, spacing: 15) {
                Text("Explorar")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text("O que estão ouvindo")
                    .font(.title)
                    .bold()
                    .foregroundColor(.primary)
                
                ZStack{
            
            Rectangle()
                .scaledToFill()
                .frame(width: 315, height: 393)
                .foregroundStyle(.gray.opacity(0.9))
                .clipShape(
                    UnevenRoundedRectangle(
                        topLeadingRadius: 5,
                        bottomLeadingRadius: 15,
                        bottomTrailingRadius: 5,
                        topTrailingRadius: 15
                    )
                    )
            
                ForEach(people, id: \.self) { person in
                    CardSwipe(person: person)}
                }
            
                // MARK: - Controles do Slider e Tempo
                VStack(spacing: 7) {
                    Slider(
                        value: Binding(
                            get: { isDraggingSlider ? localSliderValue : audioManager.playbackProgress },
                            set: { localSliderValue = $0 }
                        ),
                        in: 0...1.0,
                        onEditingChanged: { editing in
                            isDraggingSlider = editing
                            if !editing {
                                audioManager.seek(to: localSliderValue)
                            }
                        }
                    )
                    
                    HStack {
                        Text(audioManager.formatTime(audioManager.currentTime))
                        Spacer()
                        Text(audioManager.formatTime(audioManager.totalDuration))
                    }
                    .font(.caption)
                    .monospacedDigit()
                    .foregroundStyle(.secondary)
                }
                
                // MARK: - Botões de Controle do Player
                HStack(spacing: 0) {
                    
                    // Voltando 10s
                    Button {
                        audioManager.seekBy(seconds: -10)
                    } label: {
                        Image(systemName: "gobackward.10")
                            .font(.system(size: 20, weight: .semibold))
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Repetir
                    Button {
                        audioManager.toggleRepeat()
                    } label: {
                        Image(systemName: audioManager.isRepeatOn ? "repeat.1" : "repeat")
                            .font(.system(size: 18))
                            .foregroundStyle(audioManager.isRepeatOn ? .blue : .primary)
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Voltar Faixa
                    Button {
                        audioManager.skipToPrevious()
                    } label: {
                        Image(systemName: "backward.end.fill")
                            .font(.system(size: 26))
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Play / Pause Principal
                    Button {
                        audioManager.togglePlayPause()
                    } label: {
                        Image(systemName: audioManager.isPlaying ? "pause.fill" : "play.fill")
                            .font(.system(size: 40))
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Avançar Faixa
                    Button {
                        audioManager.skipToNext()
                    } label: {
                        Image(systemName: "forward.end.fill")
                            .font(.system(size: 26))
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Avançar 10s
                    Button {
                        audioManager.seekBy(seconds: 10)
                    } label: {
                        Image(systemName: "goforward.10")
                            .font(.system(size: 20, weight: .semibold))
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Shuffle
                    Button {
                        audioManager.toggleShuffle()
                    } label: {
                        Image(systemName: "shuffle")
                            .font(.system(size: 18))
                            .foregroundStyle(audioManager.isShuffleOn ? .blue : .primary)
                    }
                    .frame(maxWidth: .infinity)
                }
                .foregroundStyle(.primary)
                           
            }
            .padding(.horizontal)
            
        }
    }
}
#Preview {
    Match()
}

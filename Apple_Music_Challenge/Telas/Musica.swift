//
//  Musica.swift
//  Apple_Music_Challenge
//
//  Created by Tais Akemi Kawaguti on 23/07/26.
//

import SwiftUI
import MusicKit

struct MusicView: View {
    
    @State private var audioManager = MusicKitPlayer()
    @State private var isDraggingSlider = false
    @State private var localSliderValue: Double = 0.0
    @State private var artworkImage: UIImage? = nil
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                Group {
                    if let artworkImage {
                        FundoTela(image: artworkImage)
                    } else {
                        LinearGradient(
                            stops: [
                                .init(color: .pink, location: 0),
                                .init(color: .red, location: 0.35),
                                .init(color: .background, location: 0.7)
                            ],
                            startPoint: .top,
                            endPoint: .center
                        )
                    }
                }
                .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 10) {
                    
                    if let artwork = audioManager.currentSong?.artwork {
                        ArtworkImage(artwork, width: 300, height: 300)
                            .scaledToFit()
                            .clipShape(
                                UnevenRoundedRectangle(
                                    topLeadingRadius: 10,
                                    bottomLeadingRadius: 30,
                                    bottomTrailingRadius: 10,
                                    topTrailingRadius: 30
                                )
                            )
                            .task(id: artwork) {

                                if let url = artwork.url(width: 300, height: 300),
                                   let data = try? Data(contentsOf: url),
                                   let uiImage = UIImage(data: data) {
                                    self.artworkImage = uiImage
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
                    Spacer()
                    
                    Text(audioManager.currentSong?.title ?? "Nenhuma música")
                        .font(.title2)
                        .bold()
                    
                    Text(audioManager.currentSong?.artistName ?? "Artista")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
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
                        // Repetir
                        Button {
                            audioManager.toggleRepeat()
                        } label: {
                            Image(systemName: audioManager.isRepeatOn ? "repeat.1" : "repeat")
                                .font(.system(size: 18))
                                .foregroundStyle(audioManager.isRepeatOn ? .blue : .primary)
                        }
                        .frame(maxWidth: .infinity)
                        
                        // Voltando 10s
                        Button {
                            audioManager.seekBy(seconds: -10)
                        } label: {
                            Image(systemName: "gobackward.10")
                                .font(.system(size: 20, weight: .semibold))
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
                    
                    Spacer()
                    
                    // MARK: - Painel de Letras / Card Inferior
                    UnevenRoundedRectangle(
                        topLeadingRadius: 10,
                        bottomLeadingRadius: 30,
                        bottomTrailingRadius: 10,
                        topTrailingRadius: 30
                    )
                    .frame(height: 140)
                    .foregroundStyle(.ultraThickMaterial)
                }
                .padding(.horizontal, 24)
                .padding(.vertical)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "apple.haptics.and.music.note")
                    }
                }
            }
        }
    }
    
    // Método auxiliar (Exemplo de extração de lógica para carregar letra de musica)
    //    private func fetchLyrics(for track: Track) async -> Track.Lyrics? {
    //        do {
    //            let detailedTrack = try await track.with([.lyrics])
    //            return detailedTrack.lyrics
    //        } catch {
    //            print("Erro ao carregar letra: \(error.localizedDescription)")
    //            return nil
    //        }
    //    }
}

#Preview {
    MusicView()
}

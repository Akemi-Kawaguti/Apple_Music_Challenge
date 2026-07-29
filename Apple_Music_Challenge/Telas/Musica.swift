//
//  Musica.swift
//  Apple_Music_Challenge
//
//  Created by Tais Akemi Kawaguti on 23/07/26.
//

import SwiftUI

struct Musica: View {
    @State private var audioManager = SpotifyManager()
    
    @State private var isDraggingSlider = false
    @State private var localSliderValue: Double = 0.0
    @State private var artworkImage: UIImage? = nil
    
    // variável pra descobrir a linha da letra
    private var activeLyricID: UUID? {
        audioManager.lyrics.last(where: { audioManager.currentTime >= $0.time })?.id
    }
    
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
                                .init(color: .green, location: 0),
                                .init(color: .blue, location: 0.25),
                                .init(color: .background, location: 0.7)
                            ],
                            startPoint: .top,
                            endPoint: .center
                        )
                    }
                }
                .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 10) {
                    
                    NowPlaying(imageSize: 200, showArtworkOnly: true)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
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
                        .tint(.white)
                        
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
                        Button {
                            audioManager.toggleRepeat()
                        } label: {
                            Image(systemName: audioManager.isRepeatOn ? "repeat.1" : "repeat")
                                .font(.system(size: 18))
                                .foregroundStyle(audioManager.isRepeatOn ? .blue : .primary)
                        }
                        .frame(maxWidth: .infinity)
                        
                        Button {
                            audioManager.seekBy(seconds: -10)
                        } label: {
                            Image(systemName: "gobackward.10")
                                .font(.system(size: 20, weight: .semibold))
                        }
                        .frame(maxWidth: .infinity)
                        
                        Button {
                            audioManager.skipToPrevious()
                        } label: {
                            Image(systemName: "backward.end.fill")
                                .font(.system(size: 26))
                        }
                        .frame(maxWidth: .infinity)
                        
                        Button {
                            audioManager.togglePlayPause()
                        } label: {
                            Image(systemName: audioManager.isPlaying ? "pause.fill" : "play.fill")
                                .font(.system(size: 40))
                        }
                        .frame(maxWidth: .infinity)
                        
                        Button {
                            audioManager.skipToNext()
                        } label: {
                            Image(systemName: "forward.end.fill")
                                .font(.system(size: 26))
                        }
                        .frame(maxWidth: .infinity)
                        
                        Button {
                            audioManager.seekBy(seconds: 10)
                        } label: {
                            Image(systemName: "goforward.10")
                                .font(.system(size: 20, weight: .semibold))
                        }
                        .frame(maxWidth: .infinity)
                        
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
                    .padding(.vertical, 10)
                    
                    Spacer()
                    
                    // MARK: - Painel de Letras (Estilo Spotify)
                    ZStack {
                        UnevenRoundedRectangle(
                            topLeadingRadius: 10,
                            bottomLeadingRadius: 30,
                            bottomTrailingRadius: 10,
                            topTrailingRadius: 30
                        )
                        .foregroundStyle(.ultraThickMaterial)
                        
                        if audioManager.lyrics.isEmpty {
                            Text("Letras não disponíveis")
                                .foregroundStyle(.secondary)
                        } else {
                           
                            ScrollViewReader { scrollProxy in
                                ScrollView(showsIndicators: false) {
                                    VStack(alignment: .leading, spacing: 18) {
                                        ForEach(audioManager.lyrics) { linha in
                                            let isCurrentLine = activeLyricID == linha.id
                                            
                                            Text(linha.text)
                                                .font(isCurrentLine ? .title2 : .title3)
                                                .fontWeight(isCurrentLine ? .bold : .medium)
                                                .foregroundStyle(isCurrentLine ? .primary : .secondary)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .id(linha.id)
                                                .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isCurrentLine)
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 30)
                                }
                                // Quando a linha ativa muda, rola suavemente para ela
                                .onChange(of: activeLyricID) { oldValue, newID in
                                    if let id = newID {
                                        withAnimation(.easeInOut(duration: 0.5)) {
                                            scrollProxy.scrollTo(id, anchor: .center)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .frame(height: 180)
                }
                .padding(.horizontal, 24)
                .padding(.vertical)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "waveform")
                    }
                }
            }
            .onAppear {
                if UserDefaults.standard.string(forKey: "spotify_access_token") == nil {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        if audioManager.accessToken == nil {
                            audioManager.authenticate()
                        }
                    }
                } else {
                    Task {
                        await audioManager.fetchCurrentPlaybackState()
                    }
                }
            }
        }
    }
}

#Preview {
    Musica()
}

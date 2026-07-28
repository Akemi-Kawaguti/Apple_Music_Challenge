//
//  MusicKitAudio.swift
//  Apple_Music_Challenge
//
//  Created by Tais Akemi Kawaguti on 27/07/26.
//

import SwiftUI
import MusicKit
import Observation

@MainActor
@Observable
final class MusicKitPlayer {
    // MARK: - Instância Nativa do Player
    private let player = ApplicationMusicPlayer.shared
    
    // MARK: - Propriedades Reativas da UI
    var isPlaying = false
    var currentSong: Song?
    
    var playbackProgress: Double = 0
    var currentTime: TimeInterval = 0
    var totalDuration: TimeInterval = 0
    
    var isShuffleOn = false
    var isRepeatOn = false
    
    // MARK: - Estado Interno
    private var timer: Timer?
    
    init() {
        setupPlayerObservation()
    }
    
    // MARK: - Autorização
    func requestAuthorization() async -> MusicAuthorization.Status {
        let status = await MusicAuthorization.request()
        return status
    }
    
    // MARK: - Iniciar Playlist / Músicas
    func loadPlaylist(_ songs: [Song], startAtIndex index: Int = 0) async {
        guard !songs.isEmpty, index < songs.count else { return }
        do {
            player.queue = ApplicationMusicPlayer.Queue(for: songs, startingAt: songs[index])
            try await player.play()
            updateCurrentSongState()
        } catch {
            print("Erro ao carregar/reproduzir músicas no MusicKit: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Controles Principais
    func play() {
        Task {
            do {
                try await player.play()
            } catch {
                print("Erro ao dar play: \(error.localizedDescription)")
            }
        }
    }
    
    func pause() {
        player.pause()
    }
    
    func togglePlayPause() {
        if isPlaying {
            pause()
        } else {
            play()
        }
    }
    
    func seek(to progress: Double) {
        guard totalDuration > 0 else { return }
        let clamped = min(1.0, max(0.0, progress))
        let targetTime = totalDuration * clamped
        
        player.playbackTime = targetTime
        self.currentTime = targetTime
        self.playbackProgress = clamped
    }
    
    func seekBy(seconds: Double) {
        guard totalDuration > 0 else { return }
        let targetTime = player.playbackTime + seconds
        let clampedTime = min(max(0.0, targetTime), totalDuration)
        
        player.playbackTime = clampedTime
        self.currentTime = clampedTime
        self.playbackProgress = clampedTime / totalDuration
    }
    
    func skipToNext() {
        Task {
            try? await player.skipToNextEntry()
            updateCurrentSongState()
        }
    }
    
    func skipToPrevious() {
        Task {

            if currentTime > 3.0 {
                seek(to: 0)
                return
            }
            try? await player.skipToPreviousEntry()
            updateCurrentSongState()
        }
    }
    
    func toggleShuffle() {
        isShuffleOn.toggle()
        player.state.shuffleMode = isShuffleOn ? .songs : .off
    }
    
    func toggleRepeat() {
        isRepeatOn.toggle()
        player.state.repeatMode = isRepeatOn ? .one : MusicPlayer.RepeatMode.none
    }
    
    // MARK: - Monitoramento do Estado do Player
    private func setupPlayerObservation() {
        // Observa mudanças do MusicKit
        startTimer()
    }
    
    private func updateCurrentSongState() {
        if let currentEntry = player.queue.currentEntry,
           case .song(let song) = currentEntry.item {
            self.currentSong = song
            self.totalDuration = song.duration ?? 0
        } else {
            self.currentSong = nil
            self.totalDuration = 0
        }
    }
    
    private func startTimer() {
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            // Forçamos o bloco inteiro a rodar no MainActor
            Task { @MainActor [weak self] in
                guard let self = self else { return }
                
                self.isPlaying = (self.player.state.playbackStatus == .playing)
                
                if let currentEntry = self.player.queue.currentEntry,
                   case .song(let song) = currentEntry.item {
                    if self.currentSong != song {
                        self.currentSong = song
                        self.totalDuration = song.duration ?? 0
                    }
                }
                
                self.currentTime = self.player.playbackTime
                if self.totalDuration > 0 {
                    self.playbackProgress = min(1.0, max(0.0, self.currentTime / self.totalDuration))
                }
            }
        }
    }
    
    // MARK: - Utilitários
    func formatTime(_ seconds: TimeInterval) -> String {
        guard seconds.isFinite, seconds >= 0 else { return "--:--" }
        let total = Int(seconds.rounded(.down))
        let m = total / 60
        let s = total % 60
        return String(format: "%d:%02d", m, s)
    }
    
    
}

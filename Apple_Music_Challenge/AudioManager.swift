//
//  AudioManager.swift
//  Apple_Music_Challenge
//
//  Created by Tais Akemi Kawaguti on 23/07/26.
//

import SwiftUI
import AVFoundation
import MediaPlayer
import Observation
import UIKit

@Observable
class AudioManager {
    
    var isPlaying = false
    var audioPlayer: AVPlayer?
    
    init() {
        setupAudioSession()
        setupRemoteCommands()
        setupDummyAudio() //audio teste
        
        UIApplication.shared.beginReceivingRemoteControlEvents() //necessario
    }
    
    // Abrir uma sessão de áudio pro iOS saber que vamos tocar som
    private func setupAudioSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .default, policy: .longFormAudio)
            try session.setActive(true)
        } catch {
            print("Failed to activate audio session: \(error.localizedDescription)")
        }
    }
    
    // Ouvir play e pause de outros dispositivos(fone) ou do control center/tela bloqueada
    private func setupRemoteCommands() {
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.playCommand.addTarget { [weak self] _ in
            self?.play()
            return .success
        }
        
        commandCenter.pauseCommand.addTarget { [weak self] _ in
            self?.pause()
            return .success
        }
    }
    
    // O que realmente vai aparecer no Now Playing
    private func updateNowPlayingInfo() {
        var nowPlayingInfo = [String: Any]() //biblioteca estatica
        
        nowPlayingInfo[MPMediaItemPropertyTitle] = "SwiftUI Symphony"
        nowPlayingInfo[MPMediaItemPropertyArtist] = "Apple Dev"
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = 180.0
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = isPlaying ? 1.0 : 0.0
        
        // PRecisa usar UIImage em vez de Image pq a API disso ainda usa as coisas de UIKit
        if let image = UIImage(systemName: "waveform.circle.fill") {
            let artwork = MPMediaItemArtwork(boundsSize: image.size) { _ in return image }
            nowPlayingInfo[MPMediaItemPropertyArtwork] = artwork
        }
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    // Precisa tocar algo mudar para uma musica local no app dps
    private func setupDummyAudio() {
        guard let url = URL(string: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3") else { return }
        audioPlayer = AVPlayer(url: url)
    }
    
    func play() {
        isPlaying = true
        audioPlayer?.play()
        updateNowPlayingInfo()
    }
    
    func pause() {
        isPlaying = false
        audioPlayer?.pause()
        updateNowPlayingInfo()
    }
}

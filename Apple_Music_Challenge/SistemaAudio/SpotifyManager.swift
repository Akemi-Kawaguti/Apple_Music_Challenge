//
//  SpotifyManager.swift
//  Apple_Music_Challenge
//
//  Created by Tais Akemi Kawaguti on 28/07/26.
//
import Foundation
import SwiftUI
import Observation
import AuthenticationServices
import UIKit
import CoreHaptics

// MARK: - Modelos de Resposta do Spotify API
struct SpotifyPlaybackState: Codable {
    let is_playing: Bool
    let progress_ms: Int?
    let item: SpotifyTrackItem?
    let device: SpotifyDevice?
    let shuffle_state: Bool
    let repeat_state: String
}

struct SpotifyTrackItem: Codable {
    let id: String
    let name: String
    let duration_ms: Int
    let artists: [SpotifyArtist]
    let album: SpotifyAlbum
}

struct SpotifyArtist: Codable {
    let name: String
}

struct SpotifyAlbum: Codable {
    let images: [SpotifyImage]
}

struct SpotifyImage: Codable {
    let url: String
}

struct SpotifyDevice: Codable {
    let id: String
    let name: String
}

struct SpotifySearchResponse: Codable {
    let tracks: SpotifyTrackSearchResult?
}

struct SpotifyTrackSearchResult: Codable {
    let items: [SpotifyTrackItem]
}

// MARK: - SpotifyManager Atualizado

@MainActor
@Observable
final class SpotifyManager: NSObject, ASWebAuthenticationPresentationContextProviding {
    
    // MARK: - Configurações da API
    private let clientID = "1eaa4fdf6c2141c8b6f7b4bc8e36db30"
    private let redirectURI = "musicapplechallenge://callback"
    private let clientSecret = "30caf67d52bc4b08b79111b88bbb4408"
    private let scopes = "user-read-currently-playing user-read-playback-state user-modify-playback-state"
    
    // MARK: - Tokens de Acesso
    var accessToken: String? {
        get { UserDefaults.standard.string(forKey: "spotify_access_token") }
        set { UserDefaults.standard.set(newValue, forKey: "spotify_access_token") }
    }
    
    // MARK: - Modelos de Letras e Músicas
    struct LyricLine: Identifiable, Codable, Equatable {
        var id = UUID()
        let time: TimeInterval
        let text: String
    }
    
    struct SpotifySong: Identifiable, Codable, Equatable {
        var id: String
        var title: String
        var artistName: String
        var albumArtworkURL: String?
        var duration: TimeInterval
    }
    
    // MARK: - Propriedades Reativas da UI
    var isPlaying = false
    var currentSong: SpotifySong?
    var lyrics: [LyricLine] = []
    
    var playbackProgress: Double = 0
    var currentTime: TimeInterval = 0
    var totalDuration: TimeInterval = 0
    
    var isShuffleOn = false
    var isRepeatOn = false
    
    private var timer: Timer?
    
    override init() {
        super.init()
        if accessToken != nil {
            startPollingPlaybackState()
        }
    }
    
    private var authSession: ASWebAuthenticationSession?
    
    // MARK: - Autorização OAuth2 com Spotify (Auth Code Flow)
        func authenticate() {
            print("👉 1. Iniciando Autenticação Auth Code Flow")
            
            guard var components = URLComponents(string: "https://accounts.spotify.com/authorize") else { return }
            
            let escopos = "user-read-currently-playing user-read-playback-state user-modify-playback-state"
            
            components.queryItems = [
                URLQueryItem(name: "client_id", value: clientID),
                URLQueryItem(name: "response_type", value: "code"),
                URLQueryItem(name: "redirect_uri", value: redirectURI),
                URLQueryItem(name: "scope", value: escopos),
                URLQueryItem(name: "show_dialog", value: "true")
            ]
            
            guard let authURL = components.url else { return }
            
            authSession = ASWebAuthenticationSession(
                url: authURL,
                callbackURLScheme: "musicapplechallenge"
            ) { [weak self] callbackURL, error in
                if let error = error {
                    print("erro no retorno da sessão de auth \(error.localizedDescription)")
                    return
                }
                guard let url = callbackURL else { return }
                
                guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
                      let code = components.queryItems?.first(where: { $0.name == "code" })?.value else {
                    print("deu erro na hora de extrair o código")
                    return
                }
                
                print("código foi recebido")
                self?.exchangeCodeForToken(code: code)
            }
            
            authSession?.presentationContextProvider = self
            authSession?.start()
        }

        // MARK: - Troca do Código pelo Access Token
        private func exchangeCodeForToken(code: String) {
            guard let url = URL(string: "https://accounts.spotify.com/api/token") else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            let authString = "\(clientID):\(clientSecret)"
            guard let authData = authString.data(using: .utf8) else { return }
            let base64Auth = authData.base64EncodedString()
            
            request.setValue("Basic \(base64Auth)", forHTTPHeaderField: "Authorization")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
            var components = URLComponents()
            components.queryItems = [
                URLQueryItem(name: "grant_type", value: "authorization_code"),
                URLQueryItem(name: "code", value: code),
                URLQueryItem(name: "redirect_uri", value: redirectURI)
            ]
            request.httpBody = components.query?.data(using: .utf8)
            
            Task {
                do {
                    let (data, response) = try await URLSession.shared.data(for: request)
                    
                    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                        print("deu erro na API do Spotify. Status code: \((response as? HTTPURLResponse)?.statusCode ?? 0)")
                        return
                    }
                    
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let token = json["access_token"] as? String {
                        DispatchQueue.main.async {
                            self.accessToken = token
                            print("Deu certo pegar o token de acesso!!!!")
                            self.startPollingPlaybackState()
                        }
                    }
                } catch {
                    print("deu erro de rede ao trocar código por token: \(error.localizedDescription)")
                }
            }
        }
    
    private func extractToken(from url: URL) {
        // O token volta no fragmento da URL (#access_token=...)
        guard let fragment = url.fragment else { return }
        let dummyURL = URL(string: "https://dummy.com?\(fragment)")
        let components = URLComponents(url: dummyURL!, resolvingAgainstBaseURL: false)
        
        if let token = components?.queryItems?.first(where: { $0.name == "access_token" })?.value {
            self.accessToken = token
            startPollingPlaybackState()
        }
    }
    
    // Suporte ao ASWebAuthenticationPresentationContextProviding
    nonisolated func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        let scenes = MainActor.assumeIsolated {
                    UIApplication.shared.connectedScenes
                } //HOUVE MUDANCA
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first { $0.isKeyWindow }
        return window ?? ASPresentationAnchor()
    }
    
    // MARK: - Sincronização em Tempo Real (Fetch do Player State)
    func fetchCurrentPlaybackState() async {
        guard let token = accessToken else { return }
        
        var request = URLRequest(url: URL(string: "https://api.spotify.com/v1/me/player")!)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // Retorno 204 indica que nenhum dispositivo está tocando
            if (response as? HTTPURLResponse)?.statusCode == 204 { return }
            
            let state = try JSONDecoder().decode(SpotifyPlaybackState.self, from: data)
            
            self.isPlaying = state.is_playing
            self.isShuffleOn = state.shuffle_state
            self.isRepeatOn = state.repeat_state != "off"
            
            if let track = state.item {
                let duration = Double(track.duration_ms) / 1000.0
                let current = Double(state.progress_ms ?? 0) / 1000.0
                
                let newSong = SpotifySong(
                    id: track.id,
                    title: track.name,
                    artistName: track.artists.first?.name ?? "Artista Desconhecido",
                    albumArtworkURL: track.album.images.first?.url,
                    duration: duration
                )
                
                // Se a música mudou, atualiza e busca a nova letra
                if self.currentSong?.id != newSong.id {
                    self.currentSong = newSong
                    Task {
                        await fetchLyrics(for: newSong)
                    }
                }
                
                self.totalDuration = duration
                self.currentTime = current
                self.playbackProgress = duration > 0 ? current / duration : 0
            }
        } catch {
            print("Erro ao atualizar player do Spotify: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Controles de Reprodução via Endpoints REST
    
    func togglePlayPause() {
        let endpoint = isPlaying ? "pause" : "play"
        sendPlayerCommand(endpoint: endpoint, method: "PUT")
        isPlaying.toggle()
    }
    
    func skipToNext() {
        sendPlayerCommand(endpoint: "next", method: "POST")
    }
    
    func skipToPrevious() {
        sendPlayerCommand(endpoint: "previous", method: "POST")
    }
    
    func seek(to progress: Double) {
        guard totalDuration > 0 else { return }
        let targetMs = Int(totalDuration * progress * 1000)
        sendPlayerCommand(endpoint: "seek?position_ms=\(targetMs)", method: "PUT")
    }
    
    func seekBy(seconds: Double) {
        let targetMs = Int((currentTime + seconds) * 1000)
        sendPlayerCommand(endpoint: "seek?position_ms=\(max(0, targetMs))", method: "PUT")
    }
    
    func toggleShuffle() {
        isShuffleOn.toggle()
        sendPlayerCommand(endpoint: "shuffle?state=\(isShuffleOn)", method: "PUT")
    }
    
    func toggleRepeat() {
        isRepeatOn.toggle()
        let mode = isRepeatOn ? "track" : "off"
        sendPlayerCommand(endpoint: "repeat?state=\(mode)", method: "PUT")
    }
    
    private func sendPlayerCommand(endpoint: String, method: String) {
        guard let token = accessToken else { return }
        guard let url = URL(string: "https://api.spotify.com/v1/me/player/\(endpoint)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        Task {
            _ = try? await URLSession.shared.data(for: request)
            await fetchCurrentPlaybackState()
        }
    }
    
        func addToQueue(trackURI: String) {
            triggerHapticFeedback(style: .medium)
            
            guard let encodedURI = trackURI.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                  let url = URL(string: "https://api.spotify.com/v1/me/player/queue?uri=\(encodedURI)") else { return }
            
            sendPlayerCommandCustom(url: url, method: "POST")
        }

        func searchTracks(query: String) async -> [SpotifySong] {
            guard let token = accessToken,
                  let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                  let url = URL(string: "https://api.spotify.com/v1/search?q=\(encodedQuery)&type=track&limit=20") else {
                return []
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            do {
                let (data, response) = try await URLSession.shared.data(for: request)
                guard (response as? HTTPURLResponse)?.statusCode == 200 else { return [] }
                
                let searchResult = try JSONDecoder().decode(SpotifySearchResponse.self, from: data)
                
                return searchResult.tracks?.items.map { track in
                    let duration = Double(track.duration_ms) / 1000.0
                    return SpotifySong(
                        id: track.id,
                        title: track.name,
                        artistName: track.artists.first?.name ?? "Artista Desconhecido",
                        albumArtworkURL: track.album.images.first?.url,
                        duration: duration
                    )
                } ?? []
                
            } catch {
                print("Erro ao realizar busca: \(error.localizedDescription)")
                return []
            }
        }

        func openSpotifyAudioSettings() {
            triggerHapticFeedback(style: .light)
            if let url = URL(string: "spotify://") {
                UIApplication.shared.open(url)
            }
        }

        func triggerHapticFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle) {
            let generator = UIImpactFeedbackGenerator(style: style)
            generator.prepare()
            generator.impactOccurred()
        }
        
        // Auxiliar privado para comandos customizados na fila
        private func sendPlayerCommandCustom(url: URL, method: String) {
            guard let token = accessToken else { return }
            var request = URLRequest(url: url)
            request.httpMethod = method
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            Task {
                do {
                    _ = try await URLSession.shared.data(for: request)
                    print("Comando executado com sucesso na fila.")
                } catch {
                    print("Erro ao enviar comando para a fila: \(error.localizedDescription)")
                }
            }
        }
    
    // MARK: - Polling do Estado da Música
    private func startPollingPlaybackState() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                await self?.fetchCurrentPlaybackState()
            }
        }
    }
    
    // MARK: - Busca de Letras Dinâmicas (Integração Externa)
    private func fetchLyrics(for song: SpotifySong) async {
        self.lyrics = [
            LyricLine(time: 2.0, text: "Início de \(song.title)"),
            LyricLine(time: 8.0, text: "Por \(song.artistName)"),
            LyricLine(time: 15.0, text: "Refrão sincronizado...")
        ]
    }
    
    func formatTime(_ seconds: TimeInterval) -> String {
        guard seconds.isFinite, seconds >= 0 else { return "--:--" }
        let total = Int(seconds.rounded(.down))
        let m = total / 60
        let s = total % 60
        return String(format: "%d:%02d", m, s)
    }
}

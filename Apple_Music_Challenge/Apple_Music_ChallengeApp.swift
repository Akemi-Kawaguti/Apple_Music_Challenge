//
//  Apple_Music_ChallengeApp.swift
//  Apple_Music_Challenge
//
//  Created by Tais Akemi Kawaguti on 21/07/26.
//

import SwiftUI

@main
struct Apple_Music_ChallengeApp: App {
    @State private var spotifyManager = SpotifyManager()
    var body: some Scene {
        WindowGroup {
            ContentView()
        }.environment(spotifyManager)
    }
}

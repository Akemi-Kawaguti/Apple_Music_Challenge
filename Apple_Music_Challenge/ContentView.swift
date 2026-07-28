//
//  ContentView.swift
//  Apple_Music_Challenge
//
//  Created by Tais Akemi Kawaguti on 21/07/26.
//

import SwiftUI

// MARK: Tab Items
enum CustomTab: String, CaseIterable {
    case home = "Home"
    case discover = "Descobrir"
    case profile = "Perfil"
    
    var icone: String {
        switch self {
        case .home:
            return "house"
        case .discover:
            return "magnifyingglass"
        case .profile:
            return "person.crop.circle"
        }
    }
    
    var index: Int {
        Self.allCases.firstIndex(of: self) ?? 0
    }
}

struct ContentView: View {
    @State private var ativoTab: CustomTab = .home
    var body: some View {
        
        ZStack(alignment: .bottom){
            
            Rectangle()
                .foregroundColor(.clear)
            
            CustomTabBar(mostrarTabBar: true, ativoTab: $ativoTab){
                isExpanded in
            } onSearchTextChange: { searchText in
            }
        }
        
    }
}

//// MARK: Blur Fade In/Out
//extension View {
//    @ViewBuilder
//    func blurFade(_ status: Bool) -> some View {
//            self
//            .compositingGroup()
//            .blur(radius: status ? 0 : 10)
//            .opacity(status ? 1 : 0)
//    }
//}

#Preview {
    ContentView()
}

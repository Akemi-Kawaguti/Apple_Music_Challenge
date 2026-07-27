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
    
    var acaoIcone: String {
        switch self {
        case .home:
            return "house.fill"
        case .discover:
            return "magnifyingglass.circlepath.fill"
        case .profile:
            return "person.crop.circle.fill"
        }
    }
    
    var index: Int {
        Self.allCases.firstIndex(of: self) ?? 0
    }
}

struct ContentView: View {
    @State private var ativoTab: CustomTab = .home
    var body: some View {
        TabView(selection: $ativoTab){
            Tab.init(value: .home){
//                ScrollView(.vertical){}
                Text("Home")
                    .toolbarVisibility(.hidden, for: .tabBar)
            }
            
            Tab.init(value: .discover){
                Text("Descobrir")
                    .toolbarVisibility(.hidden, for: .tabBar)

            }
            
            Tab.init(value: .profile){
                Text("Perfil")
                    .toolbarVisibility(.hidden, for: .tabBar)

            }
        }
        .safeAreaBar(edge: .bottom, spacing: 0){
            CustomTabView()
                .padding(.horizontal, 20)
        }

        }
    @ViewBuilder
    func CustomTabView() -> some View {
        GlassEffectContainer(spacing: 10){
            HStack {
                GeometryReader {
                    TabBar(tamanho: $0.size, ativoTab: $ativoTab)
                        .overlay{
                            HStack(spacing: 0){
                                ForEach(CustomTab.allCases, id: \.rawValue){ tab in
                                    VStack(spacing: 3){
                                        Image(systemName: tab.icone)
                                            .font(.title3)
                                        Text(tab.rawValue)
                                            .font(.system(size: 10))
                                            .fontWeight(.medium)
                                    }
                                    .symbolVariant(.fill)
                                    .foregroundStyle(ativoTab == tab ? .blue : .primary)
                                    .frame(maxWidth: .infinity)
                                }
                            }.animation(.easeInOut(duration: 0.25), value: ativoTab)
                        }
                        .glassEffect(.regular.interactive(), in: .capsule)
                }
                
                ZStack {
                    ForEach(CustomTab.allCases, id: \.rawValue){
                        tab in Image(systemName: tab.icone)
                            .font(.system(size: 22, weight: .medium))
                            .blurFade(ativoTab == tab)
                    }
                } .frame(width: 55, height: 55)
                    .glassEffect(.regular.interactive(), in: .capsule)
                    .animation(.smooth(duration: 0.55, extraBounce: 0), value: ativoTab)
                
            }
            }.frame(height: 55)
    }
    
    }

// MARK: Blur Fade In/Out
extension View {
    @ViewBuilder
    func blurFade(_ status: Bool) -> some View {
            self
            .compositingGroup()
            .blur(radius: status ? 0 : 10)
            .opacity(status ? 1 : 0)
    }
}

#Preview {
    ContentView()
}

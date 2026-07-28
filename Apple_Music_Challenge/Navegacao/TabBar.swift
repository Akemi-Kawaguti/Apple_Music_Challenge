//
//  TabBar.swift
//  Apple_Music_Challenge
//
//  Created by Tais Akemi Kawaguti on 27/07/26.
//

import SwiftUI

struct CustomTabBar: View{
    var mostrarTabBar: Bool = false
    @Binding var ativoTab: CustomTab
    var onSearchExpanded: (Bool) -> ()
    var onSearchTextChange: (String) -> ()
    
    @GestureState private var isActive: Bool = false
    @State private var isInitialOffSet: Bool = false
    @State private var dragOffset: CGFloat = 0
    @State private var lastDragOffset: CGFloat?
    
    @State private var isSearchExpanded: Bool = false
    @State private var searchText: String = ""
    @FocusState private var isKeyboardActive: Bool
    
    var body: some View {
        GeometryReader{
            let tamanho = $0.size
            let tabs = CustomTab.allCases.prefix(mostrarTabBar ? 4 : CustomTab.allCases.count)
            let tabItemWidth: CGFloat = max(min(tamanho.width / CGFloat(tabs.count) + (mostrarTabBar ? 1 : 0), 90), 60)
            let tabItemHeight: CGFloat = 56
            
            ZStack{
                if isInitialOffSet{
                    let mainLayout = isKeyboardActive ? AnyLayout(ZStackLayout(alignment: .leading)) : AnyLayout(HStackLayout(spacing: 12))
                    
                    mainLayout{
                        let tabLayout = isSearchExpanded ? AnyLayout(ZStackLayout()) : AnyLayout(HStackLayout(spacing: 0))
                        
                        tabLayout{
                            ForEach(tabs, id: \.rawValue){ tab in
                                TabItemView(tab,
                                            width: isSearchExpanded ? 45 : tabItemWidth,
                                            height: isSearchExpanded ? 45 : tabItemHeight)
                                .opacity(isSearchExpanded ? (ativoTab == tab ? 1 : 0) : 1)
                            }
                        }
                        .background(alignment: .leading){
                            ZStack{
                                Capsule(style: .continuous)
                                    .stroke(.gray.opacity(0.25), lineWidth: 3)
                                    .opacity(isActive ? 1 : 0)
                                
                                Capsule(style: .continuous)
                                    .fill(.background.opacity(90))
                            }
                            .compositingGroup()
                            .frame(maxWidth: tabItemWidth, maxHeight: tabItemHeight)
                            .scaleEffect(isActive ? 1.3 : 1)
                            .offset(x: isSearchExpanded ? 0 : dragOffset)
                            .opacity(isSearchExpanded ? 0 : 1)
                        }
                        .padding(3)
                        .background(TabBarBackground())
                        .overlay{
                            if isSearchExpanded{
                                Capsule()
                                    .foregroundStyle(.clear)
                                    .contentShape(.capsule)
                                    .onTapGesture {
                                        withAnimation(.bouncy){
                                            isSearchExpanded = false
                                        }
                                    }
                            }
                        }
                        .opacity(isKeyboardActive ? 0 : 1)
                        
                        if mostrarTabBar{
                            ExpandedSearchBar(height: isSearchExpanded ? 45 : tabItemHeight)
                        }
                    }
                    .optionalGeometryGroup()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .onAppear{
                guard !isInitialOffSet else { return }
                dragOffset = CGFloat(ativoTab.index) * tabItemWidth
                isInitialOffSet = true
            }
            
        }
        .frame(height: 56)
        .padding(.horizontal, 25)
        .padding(.bottom, isKeyboardActive ? 10 : 0)
        
        .animation(.bouncy, value: dragOffset)
        .animation(.bouncy, value: isActive)
        .animation(.bouncy, value: ativoTab)
        .animation(.easeInOut(duration: 0.25), value: isKeyboardActive)
        .customnChange(value: isKeyboardActive){
            onSearchExpanded($0)
        }
        .customnChange(value: searchText){
            onSearchTextChange($0)
        }
    }
    
    //Tab Item View
    @ViewBuilder
    private func TabItemView(_ tab: CustomTab, width: CGFloat, height: CGFloat) -> some View {
        let tabs = CustomTab.allCases.prefix(mostrarTabBar ? 4 : CustomTab.allCases.count)
        let tabCount = tabs.count - 1
        
        VStack(spacing: 6){
            Image(systemName: tab.icone)
                .font(.title2)
                .symbolVariant(.fill)
            
            if !isSearchExpanded{
                Text(tab.rawValue)
                    .font(.caption)
                    .lineLimit(1)
            }
        }
        .foregroundStyle(ativoTab == tab ? accentColor : .primary)
        .frame(width: width, height: height)
        .contentShape(.capsule)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .updating($isActive, body: {_, out, _ in out = true
                })
                .onChanged ({ value in
                    let xOffset = value.translation.width
                    if let lastDragOffset{
                        let newDragOffset = xOffset + lastDragOffset
                        dragOffset = max(min(newDragOffset, CGFloat(tabCount) * width), 0)
                    } else {
                        lastDragOffset = dragOffset
                    }
                })
                .onEnded({ value in
                    lastDragOffset = nil
                    
                    let landingIndex = Int((dragOffset / width).rounded())
                    
                    if tabs.indices.contains(landingIndex) {
                        dragOffset = CGFloat(landingIndex) * width
                        ativoTab = tabs[landingIndex]
                    }
                })
        )
        .simultaneousGesture(
            TapGesture()
                .onEnded {_ in
                    ativoTab = tab
                    dragOffset = CGFloat(tab.index) * width
                }
        )
        .optionalGeometryGroup()
    }
    
    @ViewBuilder
    private func TabBarBackground() -> some View {
        ZStack{
            Capsule(style: .continuous)
                .stroke(.gray.opacity(0.25), lineWidth: 1.5)
            
            Capsule(style: .continuous)
                .fill(.background.opacity(0.8))
            
            Capsule(style: .continuous)
                .fill(.ultraThinMaterial)
        }
        .compositingGroup()
    }
    
    @ViewBuilder
    private func ExpandedSearchBar(height: CGFloat) -> some View {
        let searchLayout = isKeyboardActive ? AnyLayout(HStackLayout(spacing: 12)) : AnyLayout(ZStackLayout(alignment: .trailing))
        
        searchLayout{
            HStack(spacing: 12){
                Image(systemName: "magnifyingglass")
                    .font(isSearchExpanded ? .body : .title2)
                    .foregroundStyle(isSearchExpanded ? .gray : .primary)
                    .frame(width: isSearchExpanded ? nil : height, height: height)
                    .onTapGesture {
                        withAnimation(.bouncy){
                            isSearchExpanded = true
                        }
                    }
                //                    .onTapGesture {
                //                        withAnimation(.bouncy) {
                //                            isSearchExpanded = true
                //                        }
                //                        // Força o foco do teclado assim que a barra expande
                //                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                //                            isKeyboardActive = true
                //                        }
                //                    }
                    .allowsHitTesting(!isSearchExpanded)
                
                if isSearchExpanded {
                    TextField("Search", text: $searchText)
                        .focused($isKeyboardActive)
                }
            }
            .padding(.horizontal, isSearchExpanded ? 15 : 0)
            .background(TabBarBackground())
            .optionalGeometryGroup()
            .zIndex(1)
            
            Button{
                isKeyboardActive = false
            } label: {
                Image(systemName: "xmark")
                    .font(.title2)
                    .foregroundStyle(.primary)
                    .frame(width: height, height: height)
                    .background(TabBarBackground())
            }
            .opacity(isKeyboardActive ? 1 : 0)
        }
    }
    var accentColor: Color {
        return .blue
    }
}

#Preview {
    ContentView()
}

extension View {
    @ViewBuilder
    func optionalGeometryGroup() -> some View {
        if #available(iOS 17, *) {
            self.geometryGroup()
        } else {
            self
        }
    }
    
    @ViewBuilder
    func customnChange<T: Equatable>(value: T, result: @escaping(T) ->()) -> some View{
        if #available(iOS 17.0, *) {
            self
                .onChange(of: value) { oldValue, newValue in
                    result(newValue)
                }
        } else {
            self
                .onChange(of: value){ newValue in
                    result(newValue)
                }
        }
    }
}

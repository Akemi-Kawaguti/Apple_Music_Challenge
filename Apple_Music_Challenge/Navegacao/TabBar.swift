//
//  TabBar.swift
//  Apple_Music_Challenge
//
//  Created by Tais Akemi Kawaguti on 27/07/26.
//

import SwiftUI


struct TabBar: UIViewRepresentable {
    var tamanho: CGSize
    var ativoCor: Color = .gray.opacity(0.15)
    
    @Binding var ativoTab: CustomTab
    
    //MARK: Funções que ditam estado da Tab Bar
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> UISegmentedControl{
        let items = CustomTab.allCases.map({_ in ""})
        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = 0
        
        DispatchQueue.main.async {
            for subview in control.subviews {
                if subview is UIImageView && subview != control.subviews.last {
                    subview.alpha = 0
                }
            }
        }
        
        control.selectedSegmentTintColor = UIColor(ativoCor)
        
        control.addTarget(context.coordinator, action: #selector(context.coordinator.tabSelecionada(_:)), for: .valueChanged)
        return control
    }
    
    func updateUIView(_ uiView: UISegmentedControl, context: Context) {
    }
    
    func sizeThatFits(_ proposal: ProposedViewSize, uiView: UISegmentedControl, context: Context) -> CGSize? {
        return tamanho
    }
    
    // MARK: Classe que coordena
    class Coordinator: NSObject, UITabBarDelegate {
        var parent: TabBar
        init(parent: TabBar) {
            self.parent = parent
        }
        
        @objc func tabSelecionada(_ control: UISegmentedControl) {
            parent.ativoTab = CustomTab.allCases[control.selectedSegmentIndex]
        }
    }
    
}//View

#Preview {
    ContentView()
}

//
//  CardSwipe.swift
//  Apple_Music_Challenge
//
//  Created by Tais Akemi Kawaguti on 28/07/26.
//

import SwiftUI

struct CardSwipe: View {
    
    
    var person: String
    @State private var offSet = CGSize.zero
    @State private var colorSwipe: Color = .black
    
    var body: some View {

        ZStack {
            Rectangle()
                .scaledToFill()
                .frame(width: 320, height: 320)
                .foregroundStyle(colorSwipe.opacity(0.9))
                .clipShape(
                    UnevenRoundedRectangle(
                        topLeadingRadius: 5,
                        bottomLeadingRadius: 15,
                        bottomTrailingRadius: 5,
                        topTrailingRadius: 15
                    )
                )
            
            HStack{
                Text(person)
                    .font(.largeTitle)
                    .foregroundColor(.pink)
            }
        }
        .offset(x: offSet.width, y: offSet.height * 0.4)
        .rotationEffect(.degrees(Double(offSet.width / 40)))
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offSet = gesture.translation
                    withAnimation{
                        chanceColorSwipe(width: offSet.width)
                    }
                } .onEnded { _ in
                    withAnimation{
                        swipeCard(width: offSet.width)
                        chanceColorSwipe(width: offSet.width)
                    }
                }
        )
    }
    func swipeCard(width: CGFloat) {
        switch width {
        case -500...(-150):
            print("\(person) removed")
            offSet = CGSize(width: -500, height: 0)
        case 150...500:
            print("\(person) added")
            offSet = CGSize(width: 500, height: 0)
            default :
            offSet = .zero
        }
    }
    
    func chanceColorSwipe(width: CGFloat) {
        switch width {
            case -500...(-130):
            colorSwipe = .red
        case 130...500:
            colorSwipe = .green
            default :
            colorSwipe = .black
        }
    }
}

#Preview {
    CardSwipe(person: "Tais")
}

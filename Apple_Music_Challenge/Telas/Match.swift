//
//  Match.swift
//  Apple_Music_Challenge
//
//  Created by Tais Akemi Kawaguti on 28/07/26.
//

import SwiftUI

struct Match: View {
    
    private var people: [String] = ["Tais", "Akemi", "Kawaguti", "Allan", "Rodrigo"].reversed()
    
    var body: some View {

        VStack{
            ZStack{
                ForEach(people, id: \.self) { person in
                    CardSwipe(person: person)
                }
            }
        }
    }
}

#Preview {
    Match()
}

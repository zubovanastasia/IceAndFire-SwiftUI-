//
//  CharacterCell.swift
//  IceAndFire(SwiftUI)
//
//  Created by Anastasiia Zubova on 16.07.2022.
//

import SwiftUI

struct CharacterCell: View {
    
    var character: IceAndFireCharacters
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .firstTextBaseline) {
                Text(character.name)
                    .multilineTextAlignment(.leading)
                Spacer()
                Button("More") {
                    
                }
                .font(.callout)
            }
            .font(.title)
            Text("Gender: " + character.gender)
            Text("Born: " + character.born)
            Text("Died: " + character.died)
        }
        .padding()
    }
}

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

struct CharacterCell_Previews: PreviewProvider {
    static var previews: some View {
        CharacterCell(character: .init(id: 34, name: "Test", gender: "Male", culture: "", born: "1234", died: "1267", titles: [""], aliases: [""], father: "", mother: "", books: [""]))
    }
}


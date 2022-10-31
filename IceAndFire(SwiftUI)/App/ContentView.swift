//
//  ContentView.swift
//  IceAndFire(SwiftUI)
//
//  Created by Anastasiia Zubova on 16.07.2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        CharacterView(model: IceAndFireViewModel(service: IceAndFireAPI()))
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterView(model: IceAndFireViewModel(service: IceAndFireAPI()))
    }
}

//
//  ContentView.swift
//  IceAndFire(SwiftUI)
//
//  Created by Anastasiia Zubova on 16.07.2022.
//

import SwiftUI

struct ContentView: View {
    let container: DIContainer = .init()
    var body: some View {
        CharacterView()
            .environmentObject(container.model)
            .environmentObject(container.filter)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

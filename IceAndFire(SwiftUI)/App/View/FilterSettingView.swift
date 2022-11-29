//
//  FilterSettingView.swift
//  IceAndFire(SwiftUI)
//
//  Created by Anastasiia Zubova on 08.11.2022.
//

import SwiftUI

struct FilterSettingsView: View {
    
    @EnvironmentObject var filter: Filter
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            List {
                ForEach(Tag.allCases) { tag in
                    Button {
                        self.changeTagState(tag)
                    } label: {
                        HStack {
                            if self.filter.tags.contains(tag) {
                                Image(systemName: "checkmark.circle.fill")
                            }
                            Text(tag.rawValue.capitalized)
                        }
                    }
                }
            }
            .navigationBarTitle(Text("Tags"))
            .navigationBarItems(trailing: Button("Done") { dismiss() } )
            
        }
    }
    
    func changeTagState(_ tag: Tag) {
        filter.tags.contains(tag)
        ? filter.tags.removeAll(where: { $0 == tag })
        : filter.tags.append(tag)
    }
}

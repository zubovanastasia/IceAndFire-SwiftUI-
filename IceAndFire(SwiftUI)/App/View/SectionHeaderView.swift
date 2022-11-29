//
//  SectionHeaderView.swift
//  IceAndFire(SwiftUI)
//
//  Created by Anastasiia Zubova on 08.11.2022.
//

import SwiftUI

struct SectionHeaderView: View {
    let header: String
    let lastUpdateTime: TimeInterval
    let currentDate: Date
    
    private var relativeTimeString: String {
        return RelativeDateTimeFormatter().localizedString(fromTimeInterval: lastUpdateTime - currentDate.timeIntervalSince1970)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(header)
            Text("last update \(relativeTimeString)")
                .font(.subheadline)
        }
    }
}

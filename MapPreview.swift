//
//  MapPreview.swift
//  ThruHiker
//
//  Created by Kai Linsley on 4/23/24.
//

import SwiftUI
import MapKit

struct MapPreview: View {
    var body: some View {
        Map()
            .border(.darkerBrown, width: 5)
    }
}

#Preview {
    MapPreview()
}

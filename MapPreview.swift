//
//  MapPreview.swift
//  ThruHiker
//
//  Created by Kai Linsley on 4/23/24.
//

import SwiftUI
import MapKit

struct MapPreview: View {
    var route: Route
    var body: some View {
        Map()
            .border(.darkerBrown, width: 5)
    }
}

#Preview {
    MapPreview(route: routes[0])
}

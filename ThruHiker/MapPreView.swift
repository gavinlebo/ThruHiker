//
//  MapView.swift
//  ThruHiker
//
//  Created by Kai Linsley on 5/20/24.
//

import SwiftUI
@_spi(Experimental) import MapboxMaps

struct MapPreView: View {
    
    @EnvironmentObject var healthKitManager: HealthKitManager

    let route: Route
    
    @State private var latitude: Double = 0.0
    @State private var longitude: Double = 0.0
    @State private var Mile: Double = 0.0
    
    var body: some View {
        Map()
        .mapStyle(MapStyle(uri: StyleURI(rawValue: route.mapURL)!))
        .ignoresSafeArea()
    }
}

#Preview {
    MapPreView(route: routes[1])
}

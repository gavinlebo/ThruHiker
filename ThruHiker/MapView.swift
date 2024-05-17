//
//  MapView.swift
//  ThruHiker
//
//  Created by Kai Linsley on 5/8/24.
//

import SwiftUI
@_spi(Experimental) import MapboxMaps

struct MapView: View {
    
    @EnvironmentObject var healthKitManager: HealthKitManager

    let route: Route
    
    @State private var latitude: Double = 0.0
    @State private var longitude: Double = 0.0
    @State private var Mile: Double = 0.0
    
    var body: some View {
        Map(){
            CircleAnnotation(centerCoordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
                .circleColor(StyleColor(.systemBlue))
                .circleRadius(7)
                .circleStrokeColor(StyleColor(.white))
                .circleStrokeWidth(1)
            
        }
        .mapStyle(MapStyle(uri: StyleURI(rawValue: route.mapURL)!))
        .ignoresSafeArea()
        .onAppear {
            let startDate = Calendar.current.date(byAdding: .month, value: -6, to: Date())!
            healthKitManager.queryDistanceWalked(from: startDate)

            Mile = healthKitManager.distanceWalked
            if let (long, lat) = JSONManager.getCoord(for: Mile, from: route.mileMarkerFile) {
                self.longitude = long
                self.latitude = lat
            }
        }
    }
}

#Preview {
    MapView(route: routes[1])
}

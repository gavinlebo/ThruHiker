//
//  RouteView.swift
//  ThruHiker
//
//  Created by Kai Linsley on 4/23/24.
//

import SwiftUI
import MapKit
//@_spi(Experimental) import MapboxMaps

struct RouteView: View {
    var body: some View {
        Map()
    }
}

/*
struct RouteView: View {
     @State private var latitude: Double = 0.0
     @State private var longitude: Double = 0.0
     @State private var Mile: Double = 1000
     
     var body: some View {
         Map(){
             CircleAnnotation(centerCoordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
                 .circleColor(StyleColor(.systemBlue))
                 .circleRadius(7)
                 .circleStrokeColor(StyleColor(.white))
                 .circleStrokeWidth(1)
             
         }
         .mapStyle(MapStyle(uri: StyleURI(rawValue: "mapbox://styles/gavinlebo/cluz1mqk2005n01q17kxdbgcl")!))
         .ignoresSafeArea()
         .onAppear(){
             print("on appear")
             if let (long, lat) = MileMarkers.getCoord(for: Mile) {
                 print("in if")
                 self.longitude = long
                 self.latitude = lat
                 print(long)
                 print(lat)
             }
             
             
         }
     }
}
*/
#Preview {
    RouteView()
}


//
//  ContentView.swift
//  ThruHiker
//
//  Created by Kai Linsley on 4/9/24.
//

import SwiftUI
@_spi(Experimental) import MapboxMaps




let location = CLLocationCoordinate2D(latitude: 35.5073219, longitude: -120)



struct ContentView: View {
    
    var body: some View {
        Map(){
            MapViewAnnotation(coordinate: location) {
                Circle().fill(.blue)
                                
                        }
        }
        .mapStyle(MapStyle(uri: StyleURI(rawValue: "mapbox://styles/gavinlebo/cluyo7p3n005b01og5wbi0v1t")!))
            .ignoresSafeArea()
        
    }
}

#Preview {
    ContentView()
}

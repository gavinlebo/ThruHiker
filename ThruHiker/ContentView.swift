
//  ContentView.swift
//  ThruHiker
//
//



import SwiftUI
@_spi(Experimental) import MapboxMaps


import Foundation

// Define the JSON data as an array of dictionaries






struct ContentView: View {
    
    
    
    
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}











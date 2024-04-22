
//  ContentView.swift
//  ThruHiker
//
//  Created by Taylor Yee on 4/14/24.
//



import SwiftUI
@_spi(Experimental) import MapboxMaps


import Foundation

// Define the JSON data as an array of dictionaries



struct MileMarker: Codable {
    let mile: Double
    let sectionName: String
    let long: Double
    let lat: Double
}





struct ContentView: View {
    
    
    
    
    @State private var latitude: Double = 0.0
    @State private var longitude: Double = 0.0
    @State private var Mile: Double = 700
    
    
    func loadMiles(from jsonFileName: String) -> [MileMarker]? {
        guard let jsonFilePath = Bundle.main.path(forResource: jsonFileName, ofType: "json") else {
            print("JSON not found")
            return nil
        }
        
        let fileUrl = URL(fileURLWithPath: jsonFilePath)
        do {
            let jsonData = try Data(contentsOf: fileUrl)
            return try JSONDecoder().decode([MileMarker].self, from: jsonData)
        } catch {
            print("Error loading JSON2")
            return nil
        }
    }
    
    func getCoord(coordMile mile: Double, with data: [MileMarker]) {
        let roundedMile = (mile * 2).rounded(.down) / 2
        if let marker = data.first(where: { $0.mile == roundedMile }) {
            self.longitude = marker.long
            self.latitude = marker.lat
        }
    }
    
    
    
    var body: some View {
        Map(){
            CircleAnnotation(centerCoordinate: CLLocationCoordinate2D(latitude: 36.71420320000004, longitude: -118.36878639999998))
                .circleColor(StyleColor(.systemBlue))
                .circleRadius(7)
                .circleStrokeColor(StyleColor(.white))
                .circleStrokeWidth(1)
            
        }
        .mapStyle(MapStyle(uri: StyleURI(rawValue: "mapbox://styles/gavinlebo/cluz1mqk2005n01q17kxdbgcl")!))
        .ignoresSafeArea()
        .onAppear(){
            if let mileMarkers = loadMiles(from: "Sorted_PCT_Miles") {
                getCoord(coordMile: Mile, with: mileMarkers)
            } else {
                print("Error loading JSON")
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}











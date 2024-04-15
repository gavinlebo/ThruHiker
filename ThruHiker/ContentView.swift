//
//  ContentView.swift
//  ThruHiker
//
//  Created by Kai Linsley on 4/9/24.
//

import SwiftUI
@_spi(Experimental) import MapboxMaps


import Foundation

// Define the JSON data as an array of dictionaries









struct ContentView: View {
    
    
    func loadJSON(from filename: String) -> Data? {
        guard let path = Bundle.main.path(forResource: filename, ofType: "json") else {
            print("Failed to locate \(filename).json in bundle.")
            return nil
        }

        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            return data
        } catch {
            print("Failed to load \(filename).json:", error)
            return nil
        }
    }
    
    func parseJSON(data: Data) -> [String: Any]? {
        do {
            // make sure this JSON is in the format we expect
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]{
                if let names = json["Mile"] as? [String] {
                    print(names)
                }
            }
                // try to read out a string array
            
            
        } catch let error as NSError {
            print("Failed to load: \(error.localizedDescription)")
            return nil
        }
    }
    
    
    
    func getLatLong(for mile: Double) -> (Double, Double)? {
        let currentDirectoryURL = FileManager.default.currentDirectoryPath
        print("Current directory: \(currentDirectoryURL)")
        
        if let jsonData = loadJSON(from: "Sorted_PCT_Miles"), let parsedData = parseJSON(data: jsonData) {
            print(parsedData)
            print("dataa\n")
//            for data in parsedData {
//                if let mileValue = data["Lat"] as? Double,
//                   let latitude = data["Lat"] as? Double,
//                   let longitude = data["Long"] as? Double,
//                   mileValue == mile {
//                    return (latitude, longitude)
//                }
//            }
        } else {
            print("Failed to load or parse JSON.")
        }
        return nil
    }
    
    @State private var latitude: Double = 0.0
    @State private var longitude: Double = 0.0
    @State private var miles: Double = 700
    
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
            if let latLong = getLatLong(for: miles) {
                latitude = latLong.0
                longitude = latLong.1
            } else {
                print("Latitude and Longitude not found for the given mile.")
            }
        }
            
        
    }
}

#Preview {
    ContentView()
}

/
//  ContentView.swift
//  ThruHiker
//
//  Created by Taylor Yee on 4/14/24.
//

import SwiftUI

struct MileMarker: Codable {
    let mile: Double
    let sectionName: String
    let long: Double
    let lat: Double
}
    
    struct ContentView: View {
        private let jsonFileName = "placeholder.json"
        private let Mile = 1.0
        
        @State private var longitude: Double = 0
        @State private var latitude: Double = 0
        
        var body: some View {
            Text("placeholder for map code")
                .onAppear {
                    if let mileMarkers = loadMiles(from: jsonFileName) {
                        getCoord(coordMile: Mile, with: mileMarkers)
                    } else {
                        print("Error loading JSON")
                    }
                }
        }


        
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
                print("Error loading JSON")
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
    }

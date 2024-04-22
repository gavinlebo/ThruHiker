
//  ContentView.swift
//  ThruHiker
//
//  Created by Taylor Yee on 4/14/24.
//



import SwiftUI

struct ContentView: View {
    @State private var long: Double?
    @State private var lat: Double?
    private var mileValueToDisplay: Double = 2 //placeholder value

    var body: some View {
        VStack {
            if let long = long, let lat = lat {
                Text("Longitude: \(long)")
                Text("Latitude: \(lat)")
            } else {
                Text("No coord found for mile value \(mileValueToDisplay)")
            }
        }
        .onAppear {
            if let (long, lat) = MileMarkers.getCoord(for: mileValueToDisplay) {
                self.long = long
                self.lat = lat
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}











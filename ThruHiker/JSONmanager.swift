//
//  JSONmanager.swift
//  ThruHiker
//
//  Created by Taylor Yee on 4/15/24.
//

import Foundation



struct MileMarkers: Codable{
    let Section_Na: String
    let Mile:Double
    let Long,Lat:Double
    
    static let allMiles: [MileMarkers] = Bundle.main.decode(file: "example2.json") //placeholder JSON
    
    static func getCoord(for mile: Double) -> (Long: Double, Lat: Double)? {
        
            let roundedMile = (mile * 2).rounded(.down) / 2
            if let marker = allMiles.first(where: { $0.Mile == roundedMile }) {
                return (marker.Long, marker.Lat)
            }
            return nil
        }
    
}


extension Bundle {
    func decode<T: Decodable>(file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Could not find \(file) in bundle.")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Could not load \(file) from bundle.")
        }
        
        let decoder = JSONDecoder()
        
        guard let loadedData = try? decoder.decode(T.self, from: data) else {
            fatalError("Could not decode \(file) from bundle.")
        }
        
        return loadedData
    }
}




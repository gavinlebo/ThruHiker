//
//  sampleRoutes.swift
//  ThruHiker
//
//  Created by Kai Linsley on 4/20/24.
//

import SwiftUI

struct Route {
    let name: String
    let distance: Int
    let time: String
    let mapURL: String
    let mileMarkerFile: String
}


// Example data
let routes = [
    Route(name: "Pacific Crest Trail", distance: 2650, time: "6 months", mapURL: "mapbox://styles/gavinlebo/cluz1mqk2005n01q17kxdbgcl", mileMarkerFile: "PCT_mile_markers"),
    Route(name: "Appalachian Trail", distance: 2190, time: "5-7 months", mapURL: "mapbox://styles/gavinlebo/clvy6j75v01s701q143iib9u5", mileMarkerFile: "AT_mile_markers"),
    Route(name: "John Muir Trail", distance: 224, time: "3-4 weeks", mapURL: "mapbox://styles/gavinlebo/clvy6lgmn016d01rdf2y9dxy5", mileMarkerFile: "AT_mile_markers")
]


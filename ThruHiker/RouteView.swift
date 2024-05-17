//
//  RouteView.swift
//  ThruHiker
//
//  Created by Kai Linsley on 4/23/24.
//

import SwiftUI

struct RouteView: View {
    
    let route: Route
    
    
    var body: some View {
        MapView(route: route)
     }
}

#Preview {
    RouteView(route: routes[1])
}

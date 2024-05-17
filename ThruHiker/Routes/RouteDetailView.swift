//
//  RouteCardDetailView.swift
//  ThruHiker
//
//  Created by Kai Linsley on 4/23/24.
//

import SwiftUI

struct RouteCardDetailView: View {
    
    var route: Route
    
    var body: some View {
        Text(route.summary)
        
        
    }
}

#Preview {
    RouteCardDetailView(route: routes[1])
}

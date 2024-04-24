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
        Text("Some details about \(route.name), a ThruHiker supported trail.")
    }
}

#Preview {
    RouteCardDetailView(route: routes[1])
}

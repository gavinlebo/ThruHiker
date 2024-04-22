//
//  ContentView.swift
//  ThruHiker
//
//  Created by Kai Linsley on 4/9/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(routes, id: \.name) { route in
                    RouteCardView(route: route)
                        .padding()
                        .cornerRadius(15)
                        .shadow(radius: 5)
                }
            }
            .padding()
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

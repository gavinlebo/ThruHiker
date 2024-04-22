//
//  RouteExplorePage.swift
//  ThruHiker
//
//  Created by Kai Linsley on 4/22/24.
//

import SwiftUI

struct RouteExplorePage: View {
    @State private var searchText = ""
    
    var body: some View {
        VStack {
            Text("Explore")
                .font(.title)
                .bold()
            
            TextField("Search ThruHikes", text: $searchText)
                .padding(10)
                .background(Color(.lightGray))
                .cornerRadius(10)
                .padding(.horizontal)
            
            ScrollView {
                LazyVStack(spacing: 20) {
                ForEach(filteredRoutes(), id: \.name) { route in
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
    
    func filteredRoutes() -> [Route] {
            if searchText.isEmpty {
                return routes
            } else {
                return routes.filter { $0.name.localizedCaseInsensitiveContains(searchText)
                }
            }
        }
}

#Preview {
    RouteExplorePage()
}

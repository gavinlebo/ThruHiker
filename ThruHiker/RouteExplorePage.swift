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
            Text("Explore ThruHikes")
                .font(.title)
                .bold()
                .padding(.horizontal)
            
            TextField("Search", text: $searchText)
                .padding(10)
                .background(Color(.lightGray))
                .cornerRadius(10)
                .padding(.horizontal)
                .padding(.bottom, 10)
            
            ScrollView {
                LazyVStack(spacing: 20) {
                ForEach(searchedRoutes(), id: \.name) { route in
                RouteCardView(route: route)
                        .padding(5)
                        .cornerRadius(15)
                        .shadow(radius: 5)
                    }
                }
                .padding()
            }
        }
    }
    
    func searchedRoutes() -> [Route] {
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

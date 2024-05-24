//
//  RouteExplorePage.swift
//  ThruHiker
//
//  Created by Kai Linsley on 4/22/24.
//

import SwiftUI

struct ExploreView: View {
    @EnvironmentObject var routeManager: RouteManager
    @State private var searchText = ""

    var body: some View {
            VStack {
                Text("Explore ThruHikes")
                    .font(.title)
                    .bold()
                    .padding(.horizontal)

                TextField("Search", text: $searchText)
                    .padding(10)
                    .background(Color("lightBrown"))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                    .shadow(radius: 20)

                ScrollView {
                    LazyVStack(spacing: 20) {
                        ForEach(routeManager.exploreRoutes.filter {
                            searchText.isEmpty || $0.name.localizedCaseInsensitiveContains(searchText)
                        }, id: \.id) { route in
                            RouteCardView(route: route)
                                .padding(5)
                                .cornerRadius(15)
                                .shadow(radius: 5)
                                .background(Color.clear)
                        }
                    }
                    .padding()
                }
                .background(Color.clear)
                .listStyle(PlainListStyle())
            }
            .background(Color("softGreen"))
    }
}

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
    }
}

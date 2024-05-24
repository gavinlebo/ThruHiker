//
//  CompletedView.swift
//  testmpabox
//
//  Created by Kai Linsley on 5/20/24.
//

import SwiftUI

struct CompletedView: View {
    @EnvironmentObject var routeManager: RouteManager

    var body: some View {
        VStack {
            Text("Completed Routes")
                .font(.title)
                .bold()
                .padding(.horizontal)

            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(routeManager.completedRoutes, id: \.id) { route in
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

#Preview {
    CompletedView()
}

//
//  RoutCardView.swift
//  ThruHiker
//
//  Created by Kai Linsley on 4/20/24.
//

import SwiftUI

struct RouteCardView: View {
    let route: Route
    
    var body: some View {
            ZStack {
                VStack(spacing: 10) {
                    MapPreview()
                        .frame(height: 150)
                        .cornerRadius(10)

                    VStack(spacing: 5) {
                        Text(route.name)
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.bottom, 5)
                            .foregroundColor(.white)
                        
                        HStack {
                            Text("Distance: \(route.distance) miles")
                            Spacer()
                            Text("Time: \(route.time)")
                        }
                        .font(.subheadline)
                        .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color("darkerBrown"))
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(.bottom, 10)
                    
                    HStack(spacing: 20) {
                        NavigationLink(destination: RouteCardDetailView(route: route)) {
                            Text("More info")
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(Color(.brown))
                                .cornerRadius(10)
                        }
                        NavigationLink(destination: RouteView()) {
                            Text("Start Route")
                                .foregroundColor(.white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(Color("dustyCedar"))
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding()
                .background(Color("lightBrown"))
                .cornerRadius(15)
                .shadow(radius: 5)
        }
    }
}

struct RouteCardView_Previews: PreviewProvider {
    static var previews: some View {
        RouteCardView(route: routes[1])
            .previewLayout(.sizeThatFits)
    }
}

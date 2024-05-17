//
//  MainView.swift
//  ThruHiker
//
//  Created by Kai Linsley on 5/11/24.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            RouteExploreView()
                .tabItem {
                    Label("First", systemImage: "1.circle")
                }
            
            RouteExploreView()
                .tabItem {
                    Label("Second", systemImage: "2.circle")
                }
        }
    }
}

#Preview {
    MainView()
}

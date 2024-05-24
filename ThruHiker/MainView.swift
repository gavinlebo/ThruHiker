//
//  MainView.swift
//  ThruHiker
//
//  Created by Kai Linsley on 5/11/24.
//

import SwiftUI

struct MainView: View {
    init() {
        UITabBar.appearance().backgroundColor = UIColor(Color("softGreen"))
        UITabBar.appearance().isTranslucent = false
    }
    
    var body: some View {
        NavigationView {
            TabView {
                ExploreView()
                    .tabItem {
                        Label("Explore", systemImage: "magnifyingglass")
                    }
                InProgressView()
                    .tabItem {
                        Label("In Progress", systemImage: "clock")
                    }
                CompletedView()
                    .tabItem {
                        Label("Completed", systemImage: "checkmark")
                    }
            }
        }
    }
}

#Preview {
    MainView()
}

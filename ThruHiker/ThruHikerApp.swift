//
//  testmpaboxApp.swift
//  testmpabox
//
//  Created by Kai Linsley on 5/18/24.
//

//
//  ThruHikerApp.swift
//  ThruHiker
//
//  Created by Kai Linsley on 5/1/24.
//

import SwiftUI

@main
struct ThruHikerApp: App {
    @StateObject private var routeManager = RouteManager(routes: routes)
    @StateObject private var healthKitManager = HealthKitManager() // Add HealthKitManager as an observed object

    var body: some Scene {
        WindowGroup {
            MainView()
            .environmentObject(routeManager)
            .environmentObject(healthKitManager)
        }
    }
}


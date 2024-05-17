//
//  ThruHikerApp.swift
//  ThruHiker
//
//  Created by Kai Linsley on 5/1/24.
//

import SwiftUI

@main
struct ThruHikerApp: App {
    @StateObject private var healthKitManager = HealthKitManager() // Add HealthKitManager as an observed object
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(healthKitManager) // Provide the HealthKitManager throughout the app
        }
    }
}

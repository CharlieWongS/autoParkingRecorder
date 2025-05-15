//
//  autoParkingRecorderApp.swift
//  autoParkingRecorder
//
//  Created by Charlie Wong on 22-04-2025.
//

import SwiftUI
import TipKit

@main
struct autoParkingRecorderApp: App {
    @StateObject private var locationManager = LocationManager()
        
    var body: some Scene {
        WindowGroup {
            ContentView()
//            Testfeature()
                .environmentObject(locationManager)
                .modelContainer(for: History.self)
        }
    }
    
    init() {
        try? Tips.configure()
//        Tips.showAllTipsForTesting() // Reset tips during testing

    }
}

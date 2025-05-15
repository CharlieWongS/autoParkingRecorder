//
//  ContentView.swift
//  autoParkingRecorder
//
//  Created by Charlie Wong on 22-04-2025.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var lm: LocationManager
  
    var body: some View {
        VStack {
            TabView {
                MapView()
                    .tabItem {
                        Image(systemName: "map")
                        Text("Map")
                        
                    }
                
                HistoryView()
                    .tabItem {
                        Image(systemName: "list.bullet")
                        Text("History")
                    }
            }
        }
    }
    
//    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
//    
//    var body: some View {
//        if hasSeenOnboarding {
//            VStack {
//                TabView {
//                    MapView()
//                        .tabItem {
//                            Image(systemName: "map")
//                            Text("Map")
//                                
//                        }
//                        
//                    HistoryView()
//                        .tabItem {
//                            Image(systemName: "list.bullet")
//                            Text("History")
//                        }
//                }
//            }
//        } else {
//                OnboardingView()
//        }
//
//    }
    
}

#Preview {
    ContentView()
        .environmentObject(LocationManager())
}

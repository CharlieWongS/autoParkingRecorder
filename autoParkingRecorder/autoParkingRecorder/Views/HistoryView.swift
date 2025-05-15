//
//  HistoryView.swift
//  autoParkingRecorder
//
//  Created by Charlie Wong on 22-04-2025.
//

import SwiftData
import SwiftUI

struct HistoryView: View {
    
    // Set up for data
    @EnvironmentObject var lm: LocationManager
    @Environment(\.modelContext) var modelContext
    @Query(sort: \History.timestamp) var history: [History]
    @State private var path = [History]()
    
    

    var body: some View {
        ZStack {
//            Color.white.opacity(0.2)
            
            VStack {
                // Header with title
                
                if history.isEmpty {
                    contentUnavailableView
                } else {
                    Text("History")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)

                    Text("72 Hours only")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .italic()
//                    .padding(.top)

                    HistoryListView()
                    Text("Auto-recording works in the background")
                        .font(.footnote)
                        .foregroundColor(.secondary)
//                        .padding()

                }
                Spacer()
            }
        }
        .onAppear(){
            lm.deleteOldHistory()
        }
        
    }
}

#Preview {
    let container = try! ModelContainer(for: History.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    
    // Insert sample data
    let context = container.mainContext
    context.insert(History(
        timestamp: Date(),
        latitude: 37.7749,
        longitude: -122.4194,
        altitude: 10,
        speed: 5,
        accuracy: 3
    ))

    return HistoryView()
        .modelContainer(container)
        .environmentObject(LocationManager())
}

extension HistoryView {
    
    private var contentUnavailableView: some View {
        ContentUnavailableView {
            Label("No Parking Record", systemImage: "car")
        } description: {
            Text("All your parking records will be displayed here.")
        }
    }
    
}

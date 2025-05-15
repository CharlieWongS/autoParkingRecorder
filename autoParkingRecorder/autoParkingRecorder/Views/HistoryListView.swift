//
//  HistoryListView.swift
//  autoParkingRecorder
//
//  Created by Charlie Wong on 04-05-2025.
//

import SwiftUI
import SwiftData
import MapKit
import TipKit

struct HistoryListView: View {
    
    //Tip
//    private let historyTip = HistoryTip()
    
    // Fetch all History entries from SwiftData
    @Query(sort: \History.timestamp, order: .reverse) var history: [History]
    @Environment(\.modelContext) private var modelContext
    
    @EnvironmentObject var lm: LocationManager

    // Marker Select
    @State private var showCopiedAlert = false
    

   var body: some View {
       List {
           listView
                  }
       .alert("Copied to clipboard and focused on map", isPresented: $showCopiedAlert) {
           Button("OK", role: .cancel) { }
       }
       .onAppear {
           lm.modelContext = modelContext
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

    return HistoryListView()
        .modelContainer(container)
        .environmentObject(LocationManager())
}

#Preview {
    return HistoryListView()
}

extension HistoryListView {
    
    private var listView: some View{
        ForEach(history) { record in

                HStack {
                    
                    Button {
                        // 1. Copy to clipboard
                        let coordinateText = "\(record.latitude), \(record.longitude)"
                        UIPasteboard.general.string = coordinateText
                        
                        // 2. Redirect map via view model or other handler
                        let coord = CLLocationCoordinate2D(latitude: record.latitude, longitude: record.longitude)
                        lm.focusLocation = coord // must exist in view model
                        lm.selectedHistory = record
                        
                        
                        // 3. Show feedback
                        showCopiedAlert = true
                        
                        //Tips
                        HistoryTip().invalidate(reason: .actionPerformed)

                        
                    } label: {
                        VStack(alignment: .leading) {
                            Text("📍 \(formattedDate(record.timestamp))")
                                .font(.headline)
                            Text("Lat: \(record.latitude), Lon: \(record.longitude)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .popoverTip(HistoryTip())
                    .buttonStyle(PlainButtonStyle())
                    .shadow(radius: 20, x: 0, y: 15)
                    
                    
                    Spacer()
                    
                    // Delete button
                    Button(role: .destructive) {
                            lm.delete(history: record)
                        } label: {
                        Image(systemName: "trash")
                                .foregroundColor(.red)
                                
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                }
            
          
        }
    }
    


    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
}

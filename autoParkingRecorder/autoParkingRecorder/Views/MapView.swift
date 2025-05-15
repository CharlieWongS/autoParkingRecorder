//
//  MapView.swift
//  autoParkingRecorder
//
//  Created by Charlie Wong on 22-04-2025.
//

import SwiftUI
import MapKit
import CoreLocation
import Foundation
import SwiftData
import TipKit

struct MapView: View {
    
//     Tips
    @State
    private var mapButtonTips = TipGroup(.ordered){
        RecordTip()
        RelocationTip()
    }
    
    
    // Fetching history data
    @Query(sort: \History.timestamp, order: .reverse) private var history: [History]
    
    // Marker Select
    @State private var showCopiedAlert = false
    
    // State for user location
    @EnvironmentObject private var lm: LocationManager
        
    // Inject model context
    @Environment(\.modelContext) private var modelContext
        
    
    var body: some View {
        ZStack {
            mapStyle
            VStack {
                Spacer()
                HStack {
                    // Psychology Mode Switching function
                    modeSwitcher
                        .padding()
                        .padding(.bottom, 10)
                    
                    Spacer()
                    // Location Buttons
                    VStack(alignment: .trailing) {
                        recordLocationButton
                            .popoverTip(mapButtonTips.currentTip as? RecordTip)
                            
                        relocationButton
                            .popoverTip(mapButtonTips.currentTip as? RelocationTip)
                    }
                    .padding()
                }
            }
        }
        .onAppear {
                    lm.startModeCheckTimer()
                }
        // Premission Checking
        .alert(isPresented: $lm.showPermissionAlert) {
            Alert(
                title: Text("Location Permission Needed"),
                message: Text("Enable location access in Settings to automatically save your parking location."),
                primaryButton: .default(Text("Open Settings"), action: {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }),
                secondaryButton: .cancel()
            )
        }
        // User location updates
        .onReceive(lm.$userLocation.compactMap { $0 }) { location in
            if lm.shouldFollowUser {
                lm.userPosition = .userLocation(fallback: .automatic)
            }
        }
        // Focus location changes
        .onReceive(lm.$focusLocation.compactMap { $0 }) { coord in
            lm.userPosition = .region(MKCoordinateRegion(center: coord, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)))
            lm.shouldFollowUser = false
        }
        .onAppear {
            lm.modelContext = modelContext
        }

        
    }
}

#Preview {
    MapView()
        .modelContainer(for: History.self)
        .environmentObject(LocationManager())

}

extension MapView {
    
    private var mapStyle: some View {
        Map(position: $lm.userPosition) {
            // Show the latest 5 locations as pins
            //ForEach(history.prefix(5)) { record in
            ForEach(history) { record in
                Annotation("",coordinate: record.coordinate) {
                    LocationMapAnnotationView()
                        .scaleEffect(lm.selectedHistory == record ? 1 : 0.7)
                        .scaleEffect((lm.focusLocation != nil) ? 1 : 0.7)
                        .shadow(radius: 10)
                        .onTapGesture {
                            
                            lm.selectedHistory = record
                            
                            // Copy to clipboard
                            let text = "\(record.latitude), \(record.longitude)"
                            UIPasteboard.general.string = text
                            
                            showCopiedAlert = true
                            
                            // Optionally, show alert or feedback
                            print("📍 Selected: \(text)")

                            // Focus on selected location
                            lm.userPosition = .region(MKCoordinateRegion(
                                center: record.coordinate,
                                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                            ))
                            lm.shouldFollowUser = false
                        }
                }
            }
            
        }
        .alert("Copied coordinate to clipboard, You may use it on Apple Map", isPresented: $showCopiedAlert) {
            Button("OK", role: .cancel) { }
        }
        .onMapCameraChange { context in
            if lm.shouldFollowUser {
                lm.shouldFollowUser = false
                print("🛑 Map camera changed. Stopping auto-follow.")
            }
        }
    }
    
    private var recordLocationButton: some View {
        Button(action: {
            lm.recordLocation(userLocation: lm.userLocation)
            RecordTip().invalidate(reason: .actionPerformed)
        }, label: {
            Image(systemName: "mappin.circle.fill")
                .resizable()
                .foregroundStyle(.red)
        })
        .frame(width: 44, height: 44)
        .shadow(radius: 15, x: 0, y: 15)
        .padding(.bottom, 20)

    }
    

    
    private var relocationButton: some View {
        Button(action: {
            lm.relocateUserPosition()
            RelocationTip().invalidate(reason: .actionPerformed)
        }, label: {
            Image(systemName: "location.circle.fill")
                .resizable()
        })
        .frame(width: 44, height: 44)
        .shadow(radius: 15, x: 0, y: 15)
    }
    
    private var modeSwitcher: some View {
        VStack(spacing: 10) {
            // Auto button
            lm.modeButton(selection: .auto, label: {
                Text("Auto")
                    .fontWeight(.semibold)
            })
            .padding(2)
            
            // Car button
            lm.modeButton(selection: .car, label: {
                Image(systemName: "car.fill")
            })
            .padding(2)

            // Bike button
            lm.modeButton(selection: .bike, label: {
                Image(systemName: "bicycle")
            })
            .padding(2)
            
        }
    }
    
}


//
//  TipsView.swift
//  autoParkingRecorder
//
//  Created by Charlie Wong on 14-05-2025.
//

import TipKit
import Foundation


import TipKit

struct RecordTip: Tip {
    var title: Text {
        Text("Tap it!")
    }
    
    var message: Text? {
        Text("Tap here to mark your location manually.")
    }
    
    var image: Image? {
        Image(systemName: "mappin.circle.fill")
    }
}

struct RelocationTip: Tip {
    var title: Text {
        Text("Tap it!")
    }
    var message: Text? {  
        Text("Tap show where you are.")
    }
    
    var image: Image? {
        Image(systemName: "location.circle.fill")
        
    }
}



struct HistoryTip: Tip {
    var title: Text {
    Text("You Parking History")
    }
    
    var message: Text? {
        Text("Tap to select the location & copy the info.")
    }
    
    var image: Image {
        Image(systemName: "list.bullet")
    }
    
}

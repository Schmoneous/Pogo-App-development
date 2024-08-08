//
//  ContentView.swift
//  Humanoid Bot
//
//  Created by Ivebens Eliacin  on 7/30/24.
//

import SwiftUI
import CoreBluetooth
import UIKit


struct ContentView: View {
    
    @State private var selectedTab = 2
    var body: some View {
        
        TabView(selection: $selectedTab) {
            Play_Screen()
                .tag(1)
            
            
            Homepage()
                .tag(2)
            
            
            Profile_Screen()
                .tag(3)
            
        }
        .overlay(alignment: .bottom){
            CustomTabView(tabSelection:$selectedTab)
                .offset(y: 20)
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

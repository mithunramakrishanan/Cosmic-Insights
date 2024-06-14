//
//  TabView.swift
//  CosmicInsights
//
//  Created by Mithun on 12/06/24.
//

import SwiftUI

struct HealthTabView: View {
    
    @State var selectedTab = "Summary"
    @EnvironmentObject var healthManager : HealthStoreManager
    var body: some View {
        
        TabView(selection: $selectedTab) {
            ContentView().tabItem {
                Text("Summary")
                               Image(systemName: "suit.heart.fill")
                                   .renderingMode(.template)
            }.tag("Summary").environmentObject(healthManager)
            
            BrowseView().tabItem {
                Text("Browse")
                               Image(systemName: "square.grid.3x3.fill")
                                   .renderingMode(.template)
            }.tag("Browse").environmentObject(healthManager)
        }
    }
}

#Preview {
    HealthTabView()
}

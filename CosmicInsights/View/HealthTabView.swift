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
            SummaryView().tabItem {
                Text("Summary")
                               Image(systemName: "suit.heart.fill")
                                   .renderingMode(.template)
            }.tag("Summary").toolbar(healthManager.showTabbar ? .visible : .hidden, for: .tabBar).environmentObject(healthManager)
            
            BrowseView().tabItem {
                Text("Browse")
                               Image(systemName: "square.grid.3x3.fill")
                                   .renderingMode(.template)
            }.tag("Browse").toolbar(healthManager.showTabbar ? .visible : .hidden, for: .tabBar).environmentObject(healthManager)
        }
    }
}

#Preview {
    HealthTabView()
}

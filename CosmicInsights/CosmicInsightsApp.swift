//
//  CosmicInsightsApp.swift
//  CosmicInsights
//
//  Created by Mithun on 12/06/24.
//

import SwiftUI

@main
struct CosmicInsightsApp: App {
    
    @StateObject var healthManager = HealthStoreManager()
    
    var body: some Scene {
        WindowGroup {
            HealthTabView().environmentObject(healthManager)
        }
    }
}

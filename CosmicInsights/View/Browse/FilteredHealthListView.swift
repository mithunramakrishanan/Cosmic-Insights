//
//  FilteredHealthListView.swift
//  CosmicInsights
//
//  Created by Mithun on 14/06/24.
//

import SwiftUI

struct FilteredHealthListView: View {
   
    @EnvironmentObject var healthManager : HealthStoreManager
    var filterType : HealthCategoriesData
    var body: some View {
        
        ZStack {
            Color(uiColor: .systemGroupedBackground).ignoresSafeArea()
            VStack {
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(spacing: 20), count: 1), content: {
                        ForEach(healthManager.filteredHealthValues.sorted{$0.title < $1.title} , id:\.id) { item in
                            
                            NavigationLink(destination: DetailView(healthData: item)) {
                                HealthCardView(healthData: item)
                            }
                        }
                    }).padding()
                }
            }
        }.onAppear {
            healthManager.getFilteredData(type: filterType.type)
            healthManager.showTabbar(show: false)
        }
        .navigationTitle(filterType.title)
    }
}

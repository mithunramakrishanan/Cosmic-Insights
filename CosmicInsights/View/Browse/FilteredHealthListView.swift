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
    @State var filteredHealthValues : [HealthDetailData] = []
    
    var body: some View {
        
        ZStack {
            Color(uiColor: .systemGroupedBackground).ignoresSafeArea()
            VStack {
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(spacing: 20), count: 1), content: {
                        ForEach(filteredHealthValues.sorted{$0.title < $1.title} , id:\.id) { item in
                            
                            if item.animate {
                                NavigationLink(destination: DetailView(healthData: item)) {
                                    HealthCardView(healthData: item)
                                }
                            }
                        }
                    }).padding()
                }
            }
        }.onAppear {
            
            filteredHealthValues = healthManager.getFilteredData(type: filterType.type)
        
            // Animation for data loading
            for(index,_) in filteredHealthValues.enumerated() {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.05) {
                    withAnimation(.interactiveSpring(response: 0.8,dampingFraction: 0.8,blendDuration: 0.8)) {
                        filteredHealthValues[index].animate = true
                    }
                }
            }
            
            
            healthManager.showTabbar(show: false)
        }
        .navigationTitle(filterType.title)
    }
}

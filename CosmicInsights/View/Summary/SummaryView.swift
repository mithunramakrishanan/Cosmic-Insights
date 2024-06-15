//
//  ContentView.swift
//  CosmicInsights
//
//  Created by Mithun on 12/06/24.
//

import SwiftUI

struct SummaryView: View {
    
    @EnvironmentObject var healthManager : HealthStoreManager
    @State var todayHealthValues : [HealthDetailData] = []
    var body: some View {
        
        NavigationView {
            
            ZStack {
                Color(uiColor: .systemGroupedBackground).ignoresSafeArea()
                VStack {
                    ScrollView {
                        LazyVGrid(columns: Array(repeating: GridItem(spacing: 20), count: 1), content: {
                            ForEach(todayHealthValues.sorted{$0.title < $1.title} , id:\.id) { item in
                                
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
                healthManager.showTabbar(show: true)
                todayHealthValues = healthManager.todayHealthValues
                
                // Animation for data loading
                for(index,_) in todayHealthValues.enumerated() {
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.05) {
                        withAnimation(.interactiveSpring(response: 0.8,dampingFraction: 0.8,blendDuration: 0.8)) {
                            todayHealthValues[index].animate = true
                        }
                    }
                }
            }
            .navigationTitle("All Health Data")
        }
    }
}

#Preview {
    
    SummaryView()
}

struct HealthCardView: View {
    
    var healthData : HealthDetailData
    
    var body: some View {
        
        GroupBox {
            
            HStack {
                Text(healthData.title).font(.system(size: 16, weight: .semibold)).foregroundColor(healthData.color)
                Spacer()
                Image(healthData.image).resizable().renderingMode(.template).foregroundColor(healthData.color).frame(width: 30,height: 30)
                
            }
            GroupBox {
                Text(healthData.amount).font(.system(size: 20,weight: .bold)).foregroundColor(.black)
            }
            if healthData.amount == "" {
                Text("").font(.system(size: 12)).foregroundColor(.gray).padding(.bottom).padding(1)
            }
            else if (checkSameDate(date: healthData.dateString)) {
                Text("Last updated on : Today at \(healthData.timeString)").font(.system(size: 12)).foregroundColor(.gray).padding(.bottom).padding(1)
            }
            else {
                Text("Last updated on : \(healthData.dateString), \(healthData.timeString)").font(.system(size: 12)).foregroundColor(.gray).padding(.bottom).padding(1)
            }
            Text(healthData.subtitle).font(.system(size: 12)).foregroundColor(.gray).padding(.bottom).padding(1)
            
        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center).backgroundStyle(Color.white).modifier(HealthCardModifier())
        
        
    }
}

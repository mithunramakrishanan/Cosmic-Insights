//
//  BrowseView.swift
//  CosmicInsights
//
//  Created by Mithun on 12/06/24.
//

import SwiftUI

struct BrowseView: View {
    
    @EnvironmentObject var healthManager : HealthStoreManager
    @State var categotyValues : [HealthCategoriesData] = []
    
    var body: some View {
        NavigationView {
            VStack {
                List(categotyValues, id: \.id) { category in
                    VStack {
                        NavigationLink(destination: FilteredHealthListView(filterType: category)) {
                            CategoryRowView(category: category)
                        }
                    }.frame(height: 40)
                }
            }
            
            .navigationTitle("Health Categories").onAppear {
                categotyValues = healthManager.getCategoriesDetails()
                healthManager.showTabbar(show: true)
            }
        }.environmentObject(healthManager)
    }
}

#Preview {
    BrowseView(categotyValues: [HealthCategoriesData(title: "Activity", image: "category_Activity", type: .ACTIVITY, color: .red)])
}

struct CategoryRowView: View {
    
    var category : HealthCategoriesData
    
    var body: some View {
        HStack {
            Image(category.image).resizable().renderingMode(.template).foregroundColor(category.color).frame(width: 30,height: 30).padding(.trailing)
            Text(category.title).font(.system(size: 20,weight: .bold))
        }
    }
}

//
//  HomeView.swift
//  ACompeleteProjet
//
//  Created by Abdul Aleem on 09/01/26.
//

import SwiftUI

struct HomeView: View {
    
    let items: [HomeItem] = [
        HomeItem(
            title: "Tester Tester Tester Tester Tester Tester Tester Tester ",
            privacy: "Private",
            label: "Label",
            sector: "Sector 18",
            imageName: "User"
        ),
        HomeItem(
            title: "Tester",
            privacy: "Private",
            label: "Label",
            sector: "Sector 18",
            imageName: "User"
        ),
        HomeItem(
            title: "Tester",
            privacy: "Private",
            label: "Label",
            sector: "Sector 18",
            imageName: "User"
        ),
        HomeItem(
            title: "Tester",
            privacy: "Private",
            label: "Label",
            sector: "Sector 18",
            imageName: "User"
        ),
        HomeItem(
            title: "Tester",
            privacy: "Private",
            label: "Label",
            sector: "Sector 18",
            imageName: "User"
        ),
    ]
    
    var body: some View {
        
        List {
            
            ForEach(items) { item in
                HomeRowView(item: item)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    
                
            }
        }
        .listStyle(.plain)
        
    }
}

#Preview {
    HomeView()
}

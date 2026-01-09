//
//  TabbarView.swift
//  ACompeleteProjet
//
//  Created by Abdul Aleem on 08/01/26.
//

import SwiftUI

struct TabbarView: View {
    var body: some View {
        TabView {
            Text("Hello, World!")
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            Text("Search View")
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            Text("Settings View")
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
            LogoutView()
                .tabItem {
                    Label("Profile", systemImage: "house.fill")
                }
        }
    }
}

#Preview {
    TabbarView()
}

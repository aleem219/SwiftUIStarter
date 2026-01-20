//
//  TabbarView.swift
//  ACompeleteProjet
//
//  Created by Abdul Aleem on 08/01/26.
//

import SwiftUI
import SwiftUI

// MARK: - Tab Enum
enum TabItem: String, CaseIterable {
    case home
    case contacts
    case music
    case favorites

    var icon: String {
        switch self {
        case .home: return "doc.text"
        case .contacts: return "person.crop.circle"
        case .music: return "music.note"
        case .favorites: return "heart"
        }
    }
}

// MARK: - Main Tab Container
struct TabbarView: View {

    @State private var selectedTab: TabItem = .home

    var body: some View {
        VStack(spacing: 0) {

            // MARK: Content
            ZStack {
                switch selectedTab {
                case .home:
                    HomeView()

                case .contacts:
     
                    SettingView()
                        .font(.largeTitle)
                case .music:
                    GridView()
                        .font(.largeTitle)

                case .favorites:
                    LogoutView()
                        .font(.largeTitle)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            // MARK: Custom Tab Bar
            CustomTabBar(selectedTab: $selectedTab)
        }
    }
}

// MARK: - Custom Tab Bar
struct CustomTabBar: View {

    @Binding var selectedTab: TabItem

    var body: some View {
        HStack(spacing: 28) {
            ForEach(TabItem.allCases, id: \.self) { tab in
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedTab = tab
                    }
                } label: {
                    ZStack(alignment: .topTrailing) {

                        Image(systemName: tab.icon)
                            .frame(height: 15)
                            .font(.system(size: 30, weight: .light))
                            .foregroundColor(
                                selectedTab == tab ? .purple : .gray
                            )
                            .padding(14)
                            .background(
                                selectedTab == tab
                                ? Color.purple.opacity(0.2)
                                : Color.clear
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 50))

//                        if tab == .contacts {
//                            Circle()
//                                .fill(Color.red)
//                                .frame(width: 8, height: 8)
//                                .offset(x: 6, y: -4)
//                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color(.systemGray6))
        .shadow(color: .black.opacity(0.08), radius: 5, y: -2)
        .ignoresSafeArea(edges: .bottom)   // ✅ GAP GONE
    }
}




// MARK: - Preview
#Preview {
    TabbarView()
}

//
//  HomeItem.swift
//  ACompeleteProjet
//
//  Created by Abdul Aleem on 09/01/26.
//
import SwiftUI
import Foundation

struct HomeItem: Identifiable {
    let id = UUID()
    let title: String
    let privacy: String
    let sector: String
    let imageName: String
}

struct HomeRowView: View {
    
    let item: HomeItem
    
    var body: some View {
        HStack(spacing: 12) {
            
            Image(item.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 120, height: 120)
                .cornerRadius(6)
                .clipped()
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.headline)
                    .foregroundColor(.green)
                
                Text(item.privacy)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
               
                
                Text(item.sector)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Button {
                print("Join tapped")
            } label: {
                Text("Join")
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .background(Color.green)
                    .cornerRadius(6)
            }
        }
        .padding(8)
        .background(Color.green.opacity(0.2))
        .cornerRadius(10)
    }
}

//
//  GridView.swift
//  ACompeleteProjet
//
//  Created by Abdul Aleem on 13/01/26.
//

import SwiftUI

struct GridView: View {
    var body: some View {
        VStack {
            VStack {
                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 280, height: 280)
                    .clipShape(.rect(cornerRadius: 20))

                Text("Bird")
                    .font(.largeTitle)
                    .fontWeight(.medium)
            }
            .padding(20)
            .background(.gray.opacity(0.25))
            .containerShape(.rect(cornerRadius: 50))
            Spacer()
        }
        .padding(.top, 40)
    }
}

#Preview {
    GridView()
}

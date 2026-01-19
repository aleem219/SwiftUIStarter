//
//  GridView.swift
//  ACompeleteProjet
//
//  Created by Abdul Aleem on 13/01/26.
//

import SwiftUI

struct GridView: View {
    var body: some View {
        Grid {
            GridRow {
                Text("Text from left")
                Text("Text from right")
            }
            Divider()
                
        }
    }
}

#Preview {
    GridView()
}

//
//  SettingView.swift
//  ACompeleteProjet
//
//  Created by Abdul Aleem on 12/01/26.
//

import SwiftUI

struct SettingView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                
                NavigationLink("Hello, world!",
                               destination: MyOtherScreen())
                Text("Hello, World!")
                Text("Hello, World!")
                Text("Hello, World!")
            }
            .navigationTitle("Abdul Aleem")
            //            .navigationBarTitleDisplayMode(.automatic)
            //            .navigationBarHidden(true )
            .navigationBarItems(
                leading:
                    HStack {
                        Image(systemName: "person.fill")
                        Image(systemName: "flame.fill")
                    }
                    ,
                trailing:
                    NavigationLink(
                        destination: MyOtherScreen(),
                        label: {
                            Image(systemName: "gear")
                        })
                    .accentColor(.red)
            )
        }
    }
}

struct MyOtherScreen: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Color.green.ignoresSafeArea(.all)
                .navigationTitle("Green Screen!")
            //                .navigationBarHidden(true)
            
            
            
            VStack {
                Button("Back Button") {
                    presentationMode.wrappedValue.dismiss()
                }
                NavigationLink("Hello, world!",
                               destination:Text("Third scrren"))
            }
        }
    }
}

#Preview {
    SettingView()
}

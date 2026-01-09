//
//  LogoutView.swift
//  ACompeleteProjet
//
//  Created by Abdul Aleem on 09/01/26.
//

import SwiftUI

struct LogoutView: View {
    var onConfirm: () -> Void = {}
    var onCancel: () -> Void = {}

    var body: some View {
        ZStack {
            // Dimmed background
            Color.black.opacity(0.5)
                .ignoresSafeArea()

            // Dialog card
            VStack(spacing: 16) {

                // Icon
                ZStack {
                    Circle()
                        .fill(Color.red.opacity(0.9))
                        .frame(width: 64, height: 64)

                    Image(systemName: "person.fill.xmark")
                        .foregroundColor(.white)
                        .font(.system(size: 28, weight: .bold))
                }
                .padding()

                // Title
                Text("Delete Account")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.brown)

                // Message
                Text("Are you sure you want to logout from this device?")
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                // Buttons
                HStack(spacing: 12) {
                    Button(action: {
                        KeychainService.remove()
                        appDelegate.moveToTabbar()
                        onCancel()
                    }) {
                        Text("No")
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red.opacity(0.15))
                            .cornerRadius(8)
                    }

                    Button(action: {
                        KeychainService.remove()
                        appDelegate.moveToLogin()
                        onConfirm()
                    }) {
                        Text("Yes")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(8)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 16)
            }
            .background(Color.white)
            .cornerRadius(16)
            .padding(.horizontal, 32)
        }
    }
}

#Preview {
    LogoutView(
        onConfirm: {
            print("Confirmed")
        },
        onCancel: {
            print("Cancelled")
        }
    )
}

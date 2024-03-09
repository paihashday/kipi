//
//  PasteIndicator.swift
//  kipi
//
//  Created by Ossi on 02/03/2024.
//

import SwiftUI

struct CodeListItemView: View {
    
    @GestureState private var tap = false
    @State private var pressed: Bool = false
    
    var codeValue: String

    var body: some View {
        HStack {
            Text(codeValue)
            Spacer()
            ZStack {
                Circle()
                    .foregroundStyle(.blue)
                
                Image(systemName: "checkmark")
                    .foregroundStyle(Color.white)
                    .font(.system(size: 7))
                    .clipShape(Rectangle().offset(y: tap ? 0 : 50))
                    .animation(.easeInOut, value: UUID())
                    .padding(5)
            }
            .frame(width: 10, height: 10)
            .padding([.leading, .trailing], 20)
            .scaleEffect(tap ? 2 : 1)
            .opacity(tap ? 1 : 0)
            .animation(.spring(response: 0.5, dampingFraction: 0.6), value: UUID())
        }
        .gesture(
            LongPressGesture(minimumDuration: 1                                                                                                                                                                                                                                                                                   )
                .updating($tap) { currentState, gestureState, transaction in
                    gestureState = currentState
                }
                .onEnded { value in
                    pressed.toggle()
                    
                    let pastboard = UIPasteboard.general
                    let hapticFeedback = UIImpactFeedbackGenerator(style: .heavy)
                    
                    pastboard.string = codeValue
                    hapticFeedback.impactOccurred()
                }
        )
    }
}

#Preview {
    CodeListItemView(codeValue: "AZERTY")
}

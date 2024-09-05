//
//  Tab.swift
//  guayaquil events
//
//  Created by Jean Mayorga on 5/9/24.
//

import SwiftUI

struct NoTap: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 1 : 1) // No escala
            .animation(nil, value: configuration.isPressed) // Sin animación
    }
}

struct TabButton: View {
    let option: String
    let isSelected: Bool
    let action: () -> Void

    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button(action: action) {
            Text(option)
                .font(.system(size: 14, weight: .medium))
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .foregroundColor(isSelected ? colorScheme == .dark ? Color.accent : Color.black : Color.gray)
                .background(isSelected ? Color.accent.opacity(0.3) : Color.gray.opacity(0.1))
                .cornerRadius(16)
        }
        .buttonStyle(NoTap())
    }
}

#Preview {
    VStack {
        TabButton(option: "Hoy", isSelected: true, action: {})
        TabButton(option: "Hoy", isSelected: false, action: {})
    }
}

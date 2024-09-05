//
//  Tab.swift
//  guayaquil events
//
//  Created by Jean Mayorga on 5/9/24.
//

import SwiftUI

struct TabButton: View {
    let option: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(option)
                .font(.system(size: 14, weight: .medium))
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .foregroundColor(isSelected ? Color.black : Color.gray)
                .background(isSelected ? Color.cyan.opacity(0.3) : Color.gray.opacity(0.1))
                .cornerRadius(16)
        }
    }
}

#Preview {
    VStack {
        TabButton(option: "Hoy", isSelected: true, action: {})
        TabButton(option: "Hoy", isSelected: false, action: {})
    }
}

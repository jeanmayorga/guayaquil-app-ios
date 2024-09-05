//
//  EventItem.swift
//  guayaquil events
//
//  Created by Jean Mayorga on 4/9/24.
//

import SwiftUI

struct BlinkViewModifier: ViewModifier {
    let duration: Double
    @State private var blinking: Bool = false

    func body(content: Content) -> some View {
        content
            .opacity(blinking ? 0.3 : 1)
            .animation(.easeInOut(duration: duration).repeatForever(), value: blinking)
            .onAppear {
                // Animation will only start when blinking value changes
                blinking.toggle()
            }
    }
}

extension View {
    func blinking(duration: Double = 1) -> some View {
        modifier(BlinkViewModifier(duration: duration))
    }
}

struct EventItemSkeleton: View {
    let primaryColor = Color(.init(gray: 0.6, alpha: 1.0))
    let secondaryColor  = Color(.init(gray: 0.8, alpha: 1.0))
    let purpleColor  = Color(.purple)
    
    var body: some View {
        VStack(alignment: .leading) {
            secondaryColor
                .frame(maxWidth: .infinity, minHeight: 200, maxHeight: 200)
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .padding(.bottom, 8)
            
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(.gray)
                secondaryColor
                    .frame(width: 94, height: 9)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
            }
            .multilineTextAlignment(.leading)
            .padding([.bottom], 1)
            
            primaryColor.frame(width: 190, height: 22).clipShape(RoundedRectangle(cornerRadius: 25))
            
            secondaryColor.frame(width: 100, height: 12).clipShape(RoundedRectangle(cornerRadius: 25))
            
        }
        .blinking(duration: 0.75)
        .padding()
        .border(width: 0.1, edges: [.bottom], color: .gray)
    }
}

#Preview {
    EventItemSkeleton()
}

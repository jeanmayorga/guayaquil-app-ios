//
//  EventItem.swift
//  guayaquil events
//
//  Created by Jean Mayorga on 4/9/24.
//

import SwiftUI

struct EdgeBorder: Shape {
    var width: CGFloat
    var edges: [Edge]

    func path(in rect: CGRect) -> Path {
        edges.map { edge -> Path in
            switch edge {
            case .top: return Path(.init(x: rect.minX, y: rect.minY, width: rect.width, height: width))
            case .bottom: return Path(.init(x: rect.minX, y: rect.maxY - width, width: rect.width, height: width))
            case .leading: return Path(.init(x: rect.minX, y: rect.minY, width: width, height: rect.height))
            case .trailing: return Path(.init(x: rect.maxX - width, y: rect.minY, width: width, height: rect.height))
            }
        }.reduce(into: Path()) { $0.addPath($1) }
    }
}

extension View {
    func border(width: CGFloat, edges: [Edge], color: Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
}

struct EventItem: View {
    let cover_image: String
    let name: String
    let start_date: String
    let end_date: String
    let location_name: String
    
    @State private var imageOpacity: Double = 0.0
    let secondaryColor  = Color(.init(gray: 0.8, alpha: 1.0))
    
    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: cover_image)) { phase in
                switch phase {
                case .empty:
                    secondaryColor
                        .frame(maxWidth: .infinity, minHeight: 200, maxHeight: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                        .padding(.bottom, 8)
                        .blinking(duration: 0.75)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity, minHeight: 200, maxHeight: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                        .opacity(imageOpacity)
                        .onAppear {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                imageOpacity = 1.0
                            }
                        }
                    
                case .failure:
                    Rectangle()
                        .fill(Color.gray)
                @unknown default:
                    Rectangle()
                        .fill(Color.gray)
                }
            }
            .frame(maxWidth: .infinity, minHeight: 200, maxHeight: 200)
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .padding(.bottom, 8)
            
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(.purple)
                Text(formatDateRange(from: start_date, to: end_date))
                    .font(.caption)
                    .bold()
                    .foregroundStyle(.purple)
            }
            .multilineTextAlignment(.leading)

            Text(name)
                .font(.title2)
                .multilineTextAlignment(.leading)
                .foregroundStyle(.black)
            Text(location_name)
                .font(.subheadline)
                .multilineTextAlignment(.leading)
                .foregroundStyle(.gray)
        }
        .padding()
        .border(width: 0.1, edges: [.bottom], color: .gray)
    }
}

#Preview {
    EventItem(
        cover_image: "https://i.imgur.com/NwT6P2i.jpeg",
        name: "Event Name ultra recontra que super hiper mega leta largo",
        start_date: "2024-05-16",
        end_date: "2026-01-01",
        location_name: "Avenida eloy alfaro"
    )
}


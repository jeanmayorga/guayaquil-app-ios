//
//  EventList.swift
//  guayaquil events
//
//  Created by Jean Mayorga on 5/9/24.
//

import SwiftUI

struct EventList: View {
    let isLoading: Bool
    let events: [Item]
    
    var body: some View {
        if isLoading {
            ForEach(0...5, id: \.self) { index in
                EventItemSkeleton()
            }
        } else if events.isEmpty {
            VStack {
                Spacer()
                Text("No hay shows o eventos.").font(.subheadline).foregroundStyle(.secondary)
                Spacer()
            }
        } else {
            LazyVStack {
                ForEach(events, id: \.id) { event in
                    EventItem(
                        cover_image: event.coverImage,
                        name: event.name,
                        start_date: event.startDate,
                        end_date: event.endDate,
                        location_name: event.locationName,
                        url: event.url
                    )
                }
            }
        }
    }
}

let mockEvents: [Item] = [
    Item(
        id: 1,
        coverImage: "1",
        name: "Concierto de Rock",
        slug: "2024-09-10",
        startDate: "2024-09-10",
        endDate: "Coliseo Voltaire",
        locationName: "https://example.com/rock-concert.jpg",
        url: "https://example.com/rock",
        lastUpdated: "2024-09-10"
    ),
    Item(
        id: 2,
        coverImage: "1",
        name: "Concierto de Rock",
        slug: "2024-09-10",
        startDate: "2024-09-10",
        endDate: "Coliseo Voltaire",
        locationName: "https://example.com/rock-concert.jpg",
        url: "https://example.com/rock",
        lastUpdated: "2024-09-10"
    ),
]

#Preview {
    EventList(
        isLoading: false,
        events: mockEvents
    )
}

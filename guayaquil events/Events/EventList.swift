//
//  EventList.swift
//  guayaquil events
//
//  Created by Jean Mayorga on 5/9/24.
//

import SwiftUI

struct EventList: View {
    let isLoading: Bool
    let events: [Event]
    let openSafariSheet: (String) -> Void
    
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
                    Button(action: { openSafariSheet(event.url) }) {
                        EventItem(
                            cover_image: event.cover_image,
                            name: event.name,
                            start_date: event.start_date,
                            end_date: event.end_date,
                            location_name: event.location_name
                        )
                        .foregroundColor(Color.primary)
                    }
                }
            }
        }
    }
}

let mockEvents: [Event] = [
//    Event(
//        id: 1,
//        cover_image: "1",
//        name: "Concierto de Rock",
//        slug: "2024-09-10",
//        start_date: "2024-09-10",
//        end_date: "Coliseo Voltaire",
//        location_name: "https://example.com/rock-concert.jpg",
//        url: "https://example.com/rock",
//        last_updated: "2024-09-10"
//    ),
//    Event(
//        id: 2,
//        cover_image: "2",
//        name: "Exposición de Arte",
//        slug: "2024-09-15",
//        start_date: "2024-09-20",
//        end_date: "Museo de Arte",
//        location_name: "https://example.com/art-exhibit.jpg",
//        url: "https://example.com/art",
//        last_updated: "2024-09-10"
//    )
]

#Preview {
    EventList(
        isLoading: false,
        events: mockEvents,
        openSafariSheet: { _ in
            print("Action works")
        }
    )
}

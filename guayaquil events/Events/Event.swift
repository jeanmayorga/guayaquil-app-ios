//
//  Event.swift
//  guayaquil events
//
//  Created by Jean Mayorga on 5/9/24.
//

import Foundation
import SwiftData

struct Event: Decodable {
    @Attribute(.unique)  let id: Int
    let cover_image: String
    let name: String
    let slug: String
    let start_date: String
    let end_date: String
    let location_name: String
    let url: String
    let last_updated: String?
}

@Model
final class Item: Identifiable {
    var id: Int
    var coverImage: String
    var name: String
    var slug: String
    var startDate: String
    var endDate: String
    var locationName: String
    var url: String
    var lastUpdated: String?
    
    init(
        id: Int,
        coverImage: String,
        name: String,
        slug: String,
        startDate: String,
        endDate: String,
        locationName: String,
        url: String,
        lastUpdated: String?
    ) {
        self.id = id
        self.coverImage = coverImage
        self.name = name
        self.slug = slug
        self.startDate = startDate
        self.endDate = endDate
        self.locationName = locationName
        self.url = url
        self.lastUpdated = lastUpdated
    }
}

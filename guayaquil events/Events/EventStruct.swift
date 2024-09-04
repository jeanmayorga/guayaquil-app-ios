//
//  EventStruct.swift
//  guayaquil events
//
//  Created by Jean Mayorga on 4/9/24.
//

import Foundation

struct Event: Decodable {
    let id: Int
    let cover_image: String
    let name: String
    let slug: String
    let start_date: String
    let end_date: String
    let location_name: String
    let url: String
    let last_updated: String?
}

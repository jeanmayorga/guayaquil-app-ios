//
//  Item.swift
//  guayaquil events
//
//  Created by Jean Mayorga on 4/9/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}

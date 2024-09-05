//
//  formatDate.swift
//  guayaquil events
//
//  Created by Jean Mayorga on 4/9/24.
//

import Foundation

func formatSingleDate(dateString: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    
    let isoFormatterWithTime = ISO8601DateFormatter()
    isoFormatterWithTime.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    
    var date: Date?
    
    if let parsedDate = isoFormatterWithTime.date(from: dateString) {
        date = parsedDate
    } else if let parsedDate = dateFormatter.date(from: dateString) {
        date = parsedDate
    }
    
    let outputFormatter = DateFormatter()
    
    outputFormatter.dateFormat = "dd 'de' MMMM 'del' yyyy HH:mm"
    
    outputFormatter.locale = Locale(identifier: "es_EC")
    
    if let date = date {
        return outputFormatter.string(from: date)
    }
    
    return "Fecha inválida"
}

func formatDateRange(from startDateString: String, to endDateString: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    
    let isoFormatterWithTime = ISO8601DateFormatter()
    isoFormatterWithTime.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    
    var startDate: Date?
    var endDate: Date?
    
    if let parsedStartDate = isoFormatterWithTime.date(from: startDateString) {
        startDate = parsedStartDate
    } else if let parsedStartDate = dateFormatter.date(from: startDateString) {
        startDate = parsedStartDate
    }
    
    if let parsedEndDate = isoFormatterWithTime.date(from: endDateString) {
        endDate = parsedEndDate
    } else if let parsedEndDate = dateFormatter.date(from: endDateString) {
        endDate = parsedEndDate
    }
    
    let outputFormatter = DateFormatter()
    
    outputFormatter.dateFormat = "EEEE, dd 'de' MMMM 'de' yyyy"
    outputFormatter.locale = Locale(identifier: "es_EC")
    
    let shortFormatter = DateFormatter()
    shortFormatter.dateFormat = "EEE dd 'de' MMM"
    shortFormatter.locale = Locale(identifier: "es_EC")
    
    if let startDate = startDate, let endDate = endDate {
        if startDate == endDate {
            return outputFormatter.string(from: startDate)
        } else {
            let formattedStartDate = shortFormatter.string(from: startDate)
            let formattedEndDate = shortFormatter.string(from: endDate)
            return "\(formattedStartDate) hasta \(formattedEndDate)"
        }
    }
    
    return "Fechas inválidas"
}

//
//  Service.swift
//  guayaquil events
//
//  Created by Jean Mayorga on 5/9/24.
//

import Foundation
import Supabase

let client = SupabaseClient(
    supabaseURL: URL(
        string: "https://amsjunwtalmacvrzwmvz.supabase.co")!,
    supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFtc2p1bnd0YWxtYWN2cnp3bXZ6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjQ5NTQyOTAsImV4cCI6MjA0MDUzMDI5MH0.XXdjp1xFHHXXIqBkAFvxnJgKbfM1yuJMUX816GbmWKA"
)

func fetchAllEvents () async -> [Event] {
    do {
        print("fetching all events request....")
        let query = client.from("events").select("*").order("start_date", ascending: true)
        let events: [Event] = try await query.execute().value
        
        print("fetching all events finished \(events.count).")
        return events
    } catch {
        print("Error fetching all events: \(error)")
        return []
    }
}

func fetchLastEventsUpdate () async -> String? {
    do {
        print("Fetching last event update request...")
        let query = client.from("events").select("*").order("start_date", ascending: true).limit(1)
        let events: [Event] = try await query.execute().value

        print("Fetching last event finished.")

        return events.first?.last_updated
    } catch {
        print("Error fetching the last event: \(error)")
        return nil
    }
}


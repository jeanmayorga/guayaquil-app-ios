//
//  ContentView.swift
//  guayaquil events
//
//  Created by Jean Mayorga on 4/9/24.
//

import SwiftUI
import Supabase

struct ContentView: View {
    @Environment(\.openURL) var openURL
    
    @State private var searchText = ""
    @State private var isLoading: Bool = true
    @State private var events : [Event] = []
    @State private var showSafari: Bool = false
    @State private var selectedURL: URL? = nil
    
    let client = SupabaseClient(
        supabaseURL: URL(
            string: "https://amsjunwtalmacvrzwmvz.supabase.co")!,
        supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFtc2p1bnd0YWxtYWN2cnp3bXZ6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjQ5NTQyOTAsImV4cCI6MjA0MDUzMDI5MH0.XXdjp1xFHHXXIqBkAFvxnJgKbfM1yuJMUX816GbmWKA"
    )
    
    var filteredEvents: [Event] {
        if searchText.isEmpty {
            return events
        } else {
            return events.filter { event in
                event.name.lowercased().contains(searchText.lowercased()) ||
                event.location_name.lowercased().contains(searchText.lowercased())
            }
        }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    if isLoading {
                        Text("Actualizando...")
                            .font(.caption)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundStyle(.gray)
                            .transition(.opacity)
                    } else {
                        if let lastUpdated = events.first?.last_updated {
                            Text("Actualizado el \(formatSingleDate(dateString: lastUpdated))")
                                .font(.caption)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundStyle(.gray)
                                .transition(.opacity)
                        }
                    }
                }
                .padding(.horizontal)
                .animation(.smooth, value: isLoading)
                
                if isLoading {
                    ForEach(0...5, id: \.self) { index in
                        EventItemSkeleton()
                    }
                } else {
                    ForEach(filteredEvents, id: \.id) { event in
                        Button( action: { openSafariSheet(url: event.url)}) {
                            EventItem(
                                cover_image: event.cover_image,
                                name: event.name,
                                start_date: event.start_date,
                                end_date: event.end_date,
                                location_name: event.location_name
                            )
                        }
                    }
                }
            }
            .navigationTitle("Guayaquil")
            .searchable(text: $searchText, prompt: "Buscar shows o eventos")
            .toolbar(content: {
                Menu {
                    Button(
                        action: { openURL(URL(string: "https://www.guayaquil.app")!)}
                    ) {
                        Label("Abrir en Safari", systemImage: "ellipsis.circle")
                        Text("Sitio web de shows")
                    }
                }
                label: {
                    Image(systemName: "ellipsis.circle")
                        .foregroundColor(.gray)
                }
            })
            .refreshable {
                fetchEvents()
            }
        }
        .sheet(isPresented: $showSafari, onDismiss: closeSafariSheet) {
            if let url = selectedURL {
                SFSafariViewWrapper(url: url)
            }
        }
        .onAppear {
            fetchEvents()
        }
    }
    
    private func fetchEvents () {
        Task {
            do {
                isLoading = true
                try await Task.sleep(for: .seconds(2))
                let result: [Event] = try await client.from("events").select("*").order("start_date", ascending: true).execute().value
                events = result
                isLoading = false
            } catch {
                print("Error fetching events: \(error)")
                isLoading = false
            }
        }
    }
    private func openSafariSheet(url: String) {
        if let safeUrl = URL(string: url) {
            selectedURL = safeUrl
            showSafari = true
        }
    }
    private func closeSafariSheet() {
        selectedURL = nil
        showSafari = false
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}

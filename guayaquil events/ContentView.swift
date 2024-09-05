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
    @State private var selectedOption = "Esta semana"
    
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
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(["Todos", "Hoy", "Esta semana", "Este mes"], id: \.self) { option in
                                TabButton(
                                    option: option,
                                    isSelected: selectedOption == option,
                                    action: {
                                        if selectedOption != option {
                                            selectedOption = option
                                            fetchEvents(date: option)
                                        }
                                    }
                                )
                            }
                        }
                        .padding(.bottom)
                    }
                    
                    if isLoading {
                        HStack {
                            Spacer()
                            ProgressView()
                                .font(.system(size: 16))
                                .padding([.trailing], 5)
                            Text("Actualizando")
                                .font(.caption)
                                .foregroundStyle(.gray)
                                .transition(.opacity)
                            Spacer()
                        }
                    } else {
                        if let lastUpdated = events.first?.last_updated {
                            HStack(alignment: .center) {
                                Spacer()
                                Image(systemName: "checkmark.gobackward")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 16))
                                Text("Actualizado \(formatSingleDate(dateString: lastUpdated))")
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                                    .transition(.opacity)
                                Spacer()
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .animation(.smooth, value: isLoading)
                
                
                EventList(
                    isLoading: isLoading,
                    events: filteredEvents,
                    openSafariSheet: openSafariSheet
                )
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
                fetchEvents(date: selectedOption)
            }
        }
        .sheet(isPresented: $showSafari, onDismiss: closeSafariSheet) {
            if let url = selectedURL {
                SFSafariViewWrapper(url: url)
            }
        }
        .onAppear {
            fetchEvents(date: selectedOption)
        }
    }
    
    private func fetchEvents (date: String) {
        Task {
            do {
                isLoading = true
                var query = client.from("events").select("*")
                
                let today = Date()
                let calendar = Calendar.current
                let todayString = formatDate(date: today)
                
                switch date {
                case "Hoy":
                    query = query.gte("end_date", value: todayString).lte("start_date", value: todayString)

                case "Esta semana":
                    let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
                    let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek)!
                    
                    let startOfWeekString = formatDate(date: startOfWeek)
                    let endOfWeekString = formatDate(date: endOfWeek)
                    
                    query = query.gte("end_date", value: startOfWeekString).lte("start_date", value: endOfWeekString)
    
                case "Este mes":
                    let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: today))!
                    let range = calendar.range(of: .day, in: .month, for: today)!
                    let endOfMonth = calendar.date(byAdding: .day, value: range.count - 1, to: startOfMonth)!
                    
                    let startOfMonthString = formatDate(date: startOfMonth)
                    let endOfMonthString = formatDate(date: endOfMonth)
                    
                    query = query.gte("end_date", value: startOfMonthString).lte("start_date", value: endOfMonthString)
                    
                default:
                    break
                }
                
                query = query.order("start_date", ascending: true) as! PostgrestFilterBuilder
            
                let result: [Event] = try await query.execute().value
                events = result
                isLoading = false
            } catch {
                print("Error fetching events: \(error)")
                isLoading = false
            }
        }
    }
    private func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
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

}

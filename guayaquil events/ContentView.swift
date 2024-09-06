//
//  ContentView.swift
//  guayaquil events
//
//  Created by Jean Mayorga on 4/9/24.
//

import SwiftUI
import SwiftData
import Supabase



struct ContentView: View {
    @Environment(\.openURL) var openURL
    @Environment(\.modelContext) private var modelContext


    @State private var searchText = ""
    @State private var isLoading: Bool = false
    @State private var selectedOption = "Esta semana"
    
    @Query(sort: \Item.startDate) private var items: [Item]

    var filteredItems: [Item] {
        let today = Date()
        let calendar = Calendar.current
        let todayString = formatDate(date: today)
        
        let dateFilteredItems: [Item] = {
            switch selectedOption {
            case "Hoy":
                return items.filter { item in
                    item.endDate >= todayString && item.startDate <= todayString
                }
            case "Esta semana":
                let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
                let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek)!
                return items.filter { item in
                    if let itemStartDate = parseDate(from: item.startDate),
                       let itemEndDate = parseDate(from: item.endDate) {
                        return itemEndDate >= startOfWeek && itemStartDate <= endOfWeek
                    }
                    return false
                }

            case "Este mes":
                let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: today))!
                let range = calendar.range(of: .day, in: .month, for: today)!
                let endOfMonth = calendar.date(byAdding: .day, value: range.count - 1, to: startOfMonth)!
                return items.filter { item in
                    if let itemStartDate = parseDate(from: item.startDate),
                       let itemEndDate = parseDate(from: item.endDate) {
                        return itemEndDate >= startOfMonth && itemStartDate <= endOfMonth
                    }
                    return false
                }
            default:
                return items
            }
        }()
        
        if searchText.isEmpty {
            return dateFilteredItems
        } else {
            return dateFilteredItems.filter { item in
                item.name.localizedStandardContains(searchText) || item.locationName.localizedStandardContains(searchText)
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
                        if let lastUpdated = items.first?.lastUpdated {
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
                    events: filteredItems
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
                        Text("Sitio web de Guayaquil")
                    }
                    Button(
                        action: { refreshEvents() }
                    ) {
                        Label("Refrescar", systemImage: "arrow.clockwise")
                    }
                }
                label: {
                    Image(systemName: "ellipsis.circle")
                        .foregroundColor(.gray)
                }
            })
        }
        .refreshable {
            refreshEvents()
        }
        .onAppear {
            loadShows()
        }
    }
    
    private func refreshEvents () {
        Task {
            isLoading = true
            removeEvents()
            try? await Task.sleep(nanoseconds: 0_500_000_000)
            loadShows()
        }
    }

    private func removeEvents () {
        for event in items {
            modelContext.delete(event)
        }
    }

    private func saveEvents (newEvents: [Event]) {
        for newEvent in newEvents {
            let newShow = Item(
                id: newEvent.id,
                coverImage: newEvent.cover_image,
                name: newEvent.name,
                slug: newEvent.slug,
                startDate: newEvent.start_date,
                endDate: newEvent.end_date,
                locationName: newEvent.location_name,
                url: newEvent.url,
                lastUpdated: newEvent.last_updated
            )
            modelContext.insert(newShow)
        }
        do {
            try modelContext.save()
        } catch {
            print("cannot save data")
        }
        print("\(newEvents.count) new events saved")
    }

    private func loadShows () {
        Task {
            let showsCount = items.count
            print("shows count: \(showsCount)")
            
            if showsCount == 0 {
                isLoading = true
                let newEvents = await fetchAllEvents()
                saveEvents(newEvents: newEvents)
                print("restoring new data to cache")
            } else {
                print("get data from cache data")
            }

            isLoading = false
        }
    }
    private func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    func parseDate(from dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd" // Ajusta este formato según cómo estén almacenadas tus fechas
        return formatter.date(from: dateString)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}


/// TODO:
/// change the dates fortmas in order to fetch automatically if the data is past
///

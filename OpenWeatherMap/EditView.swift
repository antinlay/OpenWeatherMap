//
//  EditView.swift
//  OpenWeatherMap
//
//  Created by Ляхевич Александр Олегович on 05.04.2024.
//

import SwiftUI

struct EditView: View {
    enum LoadingState {
        case loading, loaded, failed
    }
    
    @Environment(\.dismiss) var dismiss
    var location: Location
    var onSave: (Location) -> Void
    
    @State private var name: String
    @State private var temp: String
    
    @State private var loadingState = LoadingState.loading
    @State private var weather = Weather()
    @State private var pages = [Page]()
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Name, temperature") {
                    switch loadingState {
                    case .loading:
                        Text("Loading...")
                    case .loaded:
                        TextField("Place name", text: $weather.name)
                        TextField("Temperature", text: Binding(
                            get: {
                                return String(format: "%.1f", weather.main.temp)
                            },
                            set: { newValue in
                                if let value = Double(newValue), !value.isNaN {
                                    weather.main.temp = value
                                }
                            }
                        ))
                    case .failed:
                        Text("Please try again later.")
                    }
                }
                
                Section("Nearby:") {
                    switch loadingState {
                    case .loading:
                        Text("Loading…")
                    case .loaded:
                        ForEach(pages, id: \.pageid) { page in
                            Text(page.title)
                                .font(.headline)
                            + Text(": ")
                            + Text(page.description)
                                .italic()
                        }
                    case .failed:
                        Text("Please try again later.")
                    }
                }
            }
            .navigationTitle("Weather")
            .toolbar {
                Button("Save") {
                    var newLocation = location
                    newLocation.name = weather.name
                    newLocation.temp = String(format: "%.1f", weather.main.temp)
                    
                    onSave(newLocation)
                    dismiss()
                }
            }
            .task {
                await fetchWeatherLocation()
                await fetchNearbyPlaces()
            }
        }
    }
    init(location: Location, onSave: @escaping (Location) -> Void) {
        self.location = location
        self.onSave = onSave
        
        _name = State(initialValue: location.name)
        _temp = State(initialValue: location.temp)
    }
    
    func fetchWeatherLocation() async {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&appid=ca0cc82a336166bf5e6f9ebc05d70056&units=metric"
        guard let url = URL(string: urlString) else {
            print("Bad URL: \(urlString)")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let items = try JSONDecoder().decode(Weather.self, from: data)
            print(urlString)
            weather = items
            loadingState = .loaded
        } catch {
            loadingState = .failed
        }
    }
        
    func fetchNearbyPlaces() async {
        let urlString = "https://ru.wikipedia.org/w/api.php?ggscoord=\(location.coordinate.latitude)%7C\(location.coordinate.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
        
        guard let url = URL(string: urlString) else {
            print("Bad URL: \(urlString)")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let items = try JSONDecoder().decode(Result.self, from: data)
            pages = items.query.pages.values.sorted()
            loadingState = .loaded
        } catch {
            loadingState = .failed
        }
    }
}

#Preview {
    EditView(location: .kazan) { _ in }
}

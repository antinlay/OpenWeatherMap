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
    
    @State private var loadingState = LoadingState.loading
    @State private var weather = WeatherData()
    @State private var pages = [Page]()
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Name, temperature") {
                    switch loadingState {
                    case .loading:
                        Text("Loading...")
                    case .loaded:
                        TextField("Place name", text: $name)
                        Text("Temperature: \(String(format: "%.1f", weather.current.temperature_2m))\(weather.current_units.temperature_2m)")
                        Text("Apparent Temperature: \(String(format: "%.1f", weather.current.apparent_temperature))\(weather.current_units.apparent_temperature)")
                        Text("Precipitation: \(String(format: "%.1f", weather.current.precipitation)) \(weather.current_units.precipitation)")
                        Text("Humidity: \(weather.current.relative_humidity_2m)\(weather.current_units.relative_humidity_2m)")
                        Text("Cloud Cover: \(weather.current.cloud_cover)\(weather.current_units.cloud_cover)")
                        Text("Pressure: \(String(format: "%.1f", weather.current.pressure_msl)) \(weather.current_units.pressure_msl)")
                        Text("Wind Speed: \(String(format: "%.1f", weather.current.wind_speed_10m)) \(weather.current_units.wind_speed_10m)")
                        Text("Wind Direction: \(weather.current.wind_direction_10m)\(weather.current_units.wind_direction_10m)")
                    case .failed:
                        Text("Please try again later.")
                    }
                }
                
                Section("Nearby:") {
                    switch loadingState {
                    case .loading:
                        Text("Loading…")
                    case .loaded:
                        let initialName = pages.first?.title ?? "New Location"
                        ForEach(pages, id: \.pageid) { page in
                            Text(page.title)
                                .font(.headline)
                            + Text(": ")
                            + Text(page.description)
                                .italic()
                        }
                        .onAppear {
                            if name == "New location" || name.isEmpty {
                                name = initialName
                            }
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
                    newLocation.name = name
                    newLocation.temperature = "\(String(format: "%.1f", weather.current.temperature_2m))\(weather.current_units.temperature_2m)"
                    newLocation.apparentTemperature = "\(String(format: "%.1f", weather.current.apparent_temperature))\(weather.current_units.apparent_temperature)"
                    newLocation.precipitation = "\(String(format: "%.1f", weather.current.precipitation)) \(weather.current_units.precipitation)"
                    newLocation.humidity = "\(weather.current.relative_humidity_2m)\(weather.current_units.relative_humidity_2m)"
                    newLocation.cloudCover = "\(weather.current.cloud_cover)\(weather.current_units.cloud_cover)"
                    newLocation.pressure = "\(String(format: "%.1f", weather.current.pressure_msl)) \(weather.current_units.pressure_msl)"
                    newLocation.windSpeed = "\(String(format: "%.1f", weather.current.wind_speed_10m)) \(weather.current_units.wind_speed_10m)"
                    newLocation.windDirection = "\(weather.current.wind_direction_10m)\(weather.current_units.wind_direction_10m)"
                    newLocation.rain = weather.current.rain
                    newLocation.showers = weather.current.showers
                    newLocation.snowfall = weather.current.snowfall
                    
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
    }
    
    func fetchWeatherLocation() async {
        let urlString = "https://api.open-meteo.com/v1/forecast?latitude=\(location.coordinate.latitude)&longitude=\(location.coordinate.longitude)&current=temperature_2m,relative_humidity_2m,apparent_temperature,is_day,precipitation,rain,showers,snowfall,weather_code,cloud_cover,pressure_msl,surface_pressure,wind_speed_10m,wind_direction_10m,wind_gusts_10m"
        guard let url = URL(string: urlString) else {
            print("Bad URL: \(urlString)")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let items = try JSONDecoder().decode(WeatherData.self, from: data)
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

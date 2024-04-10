//
//  ContentView-ViewModel.swift
//  OpenWeatherMap
//
//  Created by Ляхевич Александр Олегович on 07.04.2024.
//

import Foundation
import CoreLocation
import MapKit

extension ContentView {
    @Observable
    class ViewModel {
        private(set) var locations: [Location]
        var selectedPlace: Location?
        var precipitation: Precipitation = .none
        
        let savePath = URL.documentsDirectory.appending(path: "SavedPlaces")
        
        init() {
            do {
                let data = try Data(contentsOf: savePath)
                locations = try JSONDecoder().decode([Location].self, from: data)
            } catch {
                locations = []
            }
        }
        
        func save() {
            do {
                let data = try JSONEncoder().encode(locations)
                try data.write(to: savePath, options: [.atomic, .completeFileProtection])
            } catch {
                print("Unable to save data.")
            }
        }
        
        func apendNewLocation(at point: CLLocationCoordinate2D) {
            let newLocation = Location(id: UUID(), name: "New location", latitude: point.latitude, longtitude: point.longitude, temperature: "", apparentTemperature: "", humidity: "", cloudCover: "", precipitation: "", pressure: "", windSpeed: "", windDirection: "")
            locations.append(newLocation)
            save()
        }
        
        func update(from newLocation: Location) {
            guard let selectedPlace else { return }
            
            if selectedPlace.rain > 0 || selectedPlace.showers > 0 {
                precipitation = .rain
            } else if selectedPlace.snowfall > 0 {
                precipitation = .snow
            } else {
                precipitation = .none
            }
            
            if let index = locations.firstIndex(of: selectedPlace) {
                locations[index] = newLocation
                save()
            }
        }
        
        enum Precipitation {
            case rain, snow, none
        }
    }
}

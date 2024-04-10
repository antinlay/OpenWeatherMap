//
//  Location.swift
//  OpenWeatherMap
//
//  Created by Ляхевич Александр Олегович on 04.04.2024.
//

import Foundation
import MapKit

struct Location: Codable, Equatable, Identifiable {
    var id: UUID
    var name: String
    var latitude: Double
    var longtitude: Double
    
    var temperature: String
    var apparentTemperature: String
    var humidity: String
    var cloudCover: String
    var precipitation: String
    var pressure: String
    var windSpeed: String
    var windDirection: String
    
    var rain: Double = 0.0
    var showers: Double = 0.0
    var snowfall: Double = 0.0
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
    }
        
    static let kazan = Location(id: UUID(), name: "Kazan", latitude: 55.78874, longtitude: 49.12214, temperature: "-1", apparentTemperature: "", humidity: "", cloudCover: "", precipitation: "", pressure: "", windSpeed: "", windDirection: "")
}

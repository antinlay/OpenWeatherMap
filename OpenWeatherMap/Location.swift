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
    var temp: String
    var latitude: Double
    var longtitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
    }
    
    static let kazan = Location(id: UUID(), name: "Kazan", temp: "-1", latitude: 55.78874, longtitude: 49.12214)
}

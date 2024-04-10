//
//  LocationManager.swift
//  OpenWeatherMap
//
//  Created by Ляхевич Александр Олегович on 08.04.2024.
//

import Foundation
import CoreLocation

@Observable
class LocationManager {
    var location: CLLocation? = nil
    
    private let locationManager = CLLocationManager()
    
    func requestUserAuthorization() async throws {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startCurrentLocationUpdates() async throws {
        for try await locationUpdate in CLLocationUpdate.liveUpdates() {
            guard let location = locationUpdate.location else { return }

            self.location = location
        }
    }
}

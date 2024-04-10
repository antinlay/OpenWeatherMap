//
//  ContentView.swift
//  OpenWeatherMap
//
//  Created by Ляхевич Александр Олегович on 28.03.2024.
//

import MapKit
import SwiftUI
import Vortex

struct ContentView: View {
    @State var locationManager: LocationManager = LocationManager()
    @State var temperature: String = ""
    @State var viewModel: ViewModel = ViewModel()
        
    var body: some View {
        ZStack {
            MapReader { proxy in
                Map(initialPosition: MapCameraPosition.region(
                    MKCoordinateRegion(center: locationManager.location?.coordinate ?? CLLocationCoordinate2D(latitude: 55.78874, longitude: 49.12214), span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)))) {
                    ForEach(viewModel.locations) { location in
                        Annotation(location.name, coordinate: location.coordinate) {
                            ZStack {
                                Image(systemName: "location.circle")
                                    .resizable()
                                    .symbolVariant(.fill)
                                    .symbolRenderingMode(.multicolor)
                                    .frame(width: 50, height: 50)
                                    .onLongPressGesture {
                                        viewModel.selectedPlace = location
                                    }
                            }
                        }
                    }
                }
                .mapStyle(.hybrid)
                .onTapGesture { position in
                    if let coordinate = proxy.convert(position, from: .local) {
                        viewModel.apendNewLocation(at: coordinate)
                    }
                }
                .sheet(item: $viewModel.selectedPlace) { place in
                    EditView(location: place) { newLocation in
                        viewModel.update(from: newLocation)
                    }
                }
                
            }
            switch viewModel.precipitation {
            case .rain:
                VortexView(.rain) {
                    Circle()
                        .fill(.white)
                        .frame(width: 32)
                        .tag("circle")
                }
                .allowsHitTesting(false)
            case .snow:
                VortexView(.snow) {
                    Circle()
                        .fill(.white)
                        .blur(radius: 5)
                        .frame(width: 32)
                        .tag("circle")
                }
                .allowsHitTesting(false)
            case .none:
                Group {}
            }
        }
        .task {
            try? await locationManager.requestUserAuthorization()
            try? await locationManager.startCurrentLocationUpdates()
            // remember that nothing will run here until the for try await loop finishes
        }
    }
}

#Preview {
    ContentView()
}

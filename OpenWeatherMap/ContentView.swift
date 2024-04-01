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
    let startPosition = MapCameraPosition.region(
        MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 55.78874, longitude: 49.12214), span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)))

    @State var temperature: String = ""
    @State var viewModel: ViewModel = ViewModel()
    
    var body: some View {
        ZStack {
            MapReader { proxy in
                Map(initialPosition: startPosition) {
                    ForEach(viewModel.locations) { location in
                        Annotation(location.name, coordinate: location.coordinate) {
                            ZStack {
                                Image(systemName: "circle")
                                    .resizable()
                                    .symbolVariant(.fill)
                                    .symbolRenderingMode(.palette)
                                    .foregroundStyle(
                                        Color.gray.opacity(0.9)
                                    )
                                    .frame(width: 60, height: 60)
                                    .onLongPressGesture {
                                        viewModel.selectedPlace = location
                                    }
                                Text("\(temperature)°C")
                                .font(.system(size: 30))                            }
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
            VortexView(.rain) {
                Circle()
                    .fill(.white)
                    .frame(width: 32)
                    .tag("circle")
            }
            .allowsHitTesting(false)
        }
    }
}

#Preview {
    ContentView()
}

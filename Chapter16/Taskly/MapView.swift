//
//  MapView.swift
//  Taskly
//
//  Created by Nathan Sebhastian on 27/09/24.
//

import SwiftUI
@preconcurrency import MapKit

struct MapView: View {
    let manager = CLLocationManager()
    @State var cameraPosition = MapCameraPosition.userLocation(fallback: .automatic)
    
    @Environment(\.dismiss) var dismiss
    @State var searchText = ""
    @State var searchResults = [MKMapItem]()
    @State var selectedLocation: MKMapItem?
    
    let empireSB = CLLocationCoordinate2D(latitude: 40.748443, longitude: -73.985650)
    
    var body: some View {
        Map(position: $cameraPosition, selection: $selectedLocation) {
            UserAnnotation()
            ForEach(searchResults, id: \.self) { item in
                let placemark = item.placemark
                Marker(placemark.name ?? "", coordinate: placemark.coordinate)
            }
        }
        .onAppear {
            manager.requestWhenInUseAuthorization()
        }
        .overlay(alignment: .top) {
            VStack(alignment: .trailing) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .padding(4)
                        .frame(width: 30, height: 30)
                        .foregroundStyle(.gray, Color(.systemBackground))
                }
                TextField("Search Location...", text: $searchText)
                    .font(.subheadline)
                    .padding(12)
                    .background(Color(.systemBackground))
                    .padding()
                    .shadow(color: .gray.opacity(0.5), radius: 10)
            }
        }
        .onSubmit(of: .text){
            Task { await searchLocation() }
        }
        .onChange(of: selectedLocation, { oldValue, newValue in
            print("Marker Selected")
        })
    }
}

extension MapView {
    func searchLocation() async {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = searchText
        
        let response = try? await MKLocalSearch(request: searchRequest).start()
        self.searchResults = response?.mapItems ?? []
    }
}

#Preview {
    MapView()
}

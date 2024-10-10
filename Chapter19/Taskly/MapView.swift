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
    @State var cameraPosition = MapCameraPosition.automatic
    
    @Environment(\.dismiss) var dismiss
    @State var searchText = ""
    @State var searchResults = [MKMapItem]()
    @State var selectedLocation: MKMapItem?
    
    @State var showLocationDetail = false
    
    @Binding var loc: String
    @Binding var lat: Double?
    @Binding var long: Double?
    
    @State var isLocationSaved = false
    
    var initialCoord: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: lat ?? 0, longitude: long ?? 0)
    }
    
    func updateCameraPosition() {
        let markRegion = MKCoordinateRegion(center: initialCoord, span: MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04))
        cameraPosition = MapCameraPosition.region(markRegion)
    }
    
    var body: some View {
        Map(position: $cameraPosition, selection: $selectedLocation) {
            Annotation(loc, coordinate: initialCoord) {
                ZStack {
                    Circle()
                        .frame(width: 32, height: 32)
                        .foregroundStyle(.blue.opacity(0.25))
                    Circle()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.white)
                    Circle()
                        .frame(width: 12, height: 12)
                        .foregroundStyle(.blue)
                }
            }
            ForEach(searchResults, id: \.self) { item in
                let placemark = item.placemark
                Marker(placemark.name ?? "", coordinate: placemark.coordinate)
            }
        }
        .onAppear {
            manager.requestWhenInUseAuthorization()
            if (lat != nil && long != nil) {
                updateCameraPosition()
            } else {
                cameraPosition = MapCameraPosition.userLocation(fallback: .automatic)
            }
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
            showLocationDetail = newValue != nil
        })
        .sheet(isPresented: $showLocationDetail, onDismiss: {
            if isLocationSaved {
                dismiss()
            }
        }) {
            LocationDetailView(selectedLocation: $selectedLocation, loc: $loc, lat: $lat, long: $long, isLocationSaved: $isLocationSaved)
                .presentationDetents([.height(360)])
                .presentationBackgroundInteraction(.enabled(upThrough: .height(360)))
                .presentationCornerRadius(10)
            
        }
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
    MapView(loc: .constant(""), lat: .constant(0), long: .constant(0))
}

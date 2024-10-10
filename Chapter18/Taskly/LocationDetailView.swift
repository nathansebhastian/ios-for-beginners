//
//  LocationDetailView.swift
//  Taskly
//
//  Created by Nathan Sebhastian on 30/09/24.
//

import SwiftUI
@preconcurrency import MapKit

struct LocationDetailView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedLocation: MKMapItem?
    
    @State var lookAround: MKLookAroundScene?
    
    @Binding var loc: String
    @Binding var lat: Double?
    @Binding var long: Double?
    
    @Binding var isLocationSaved: Bool
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(selectedLocation?.placemark.name ?? "")
                        .font(.title2)
                        .fontWeight(.semibold)
                    Text(selectedLocation?.placemark.title ?? "")
                        .font(.footnote)
                        .foregroundStyle(.gray)
                        .lineLimit(2)
                        .padding(.trailing)
                }
                Spacer()
                Button {
                    dismiss()
                    selectedLocation = nil
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.gray, Color(.systemBackground))
                }
            }
            if let scene = lookAround {
                LookAroundPreview(initialScene: scene)
                    .frame(height: 200)
                    .presentationCornerRadius(10)
                    .padding()
            } else {
                ContentUnavailableView("No preview available", systemImage: "eye.slash")
            }
            HStack(spacing: 24) {
                Button {
                    loc = selectedLocation?.name ?? ""
                    lat = selectedLocation?.placemark.location?.coordinate.latitude
                    long = selectedLocation?.placemark.location?.coordinate.longitude
                    isLocationSaved = true
                    dismiss()
                } label: {
                    Text("Save Location")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(width: 170, height: 48)
                        .background(.green)
                        .presentationCornerRadius(10)
                }
                
                Button {
                    if let selectedLocation {
                        selectedLocation.openInMaps()
                    }
                } label: {
                    Text("Open in Maps")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(width: 170, height: 48)
                        .background(.blue)
                        .presentationCornerRadius(10)
                }
            }
        }
        .onAppear {
            fetchLookAroundPreview()
        }
        .onChange(of: selectedLocation) { oldValue, newValue in
            fetchLookAroundPreview()
        }
        .padding()
    }
}

extension LocationDetailView {
    func fetchLookAroundPreview() {
        if let selectedLocation {
            lookAround = nil
            Task {
                let request = MKLookAroundSceneRequest(mapItem: selectedLocation)
                lookAround = try? await request.scene
            }
        }
    }
}

#Preview {
    LocationDetailView(selectedLocation: .constant(nil), loc: .constant(""), lat: .constant(0), long: .constant(0), isLocationSaved: .constant(true))
}

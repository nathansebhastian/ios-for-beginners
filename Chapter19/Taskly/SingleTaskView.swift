//
//  SingleTaskView.swift
//  Taskly
//
//  Created by Nathan Sebhastian on 20/09/24.
//

import SwiftUI
import SwiftUIImageViewer
import MapKit
import WidgetKit

struct SingleTaskView: View {
    @Environment(\.scenePhase) var scenePhase
    let task: TaskItem
    
    @State var isImageFullScreen = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    Text(task.title)
                        .font(.headline)
                    Text(task.notes)
                        .font(.subheadline)
                    Text(task.dueDate, format: Date.FormatStyle(date: .abbreviated, time: .shortened))
                        .font(.subheadline)
                }
                Spacer()
                Button {
                    withAnimation(){
                        task.isCompleted.toggle()
                    }
                    WidgetCenter.shared.reloadAllTimelines()
                } label: {
                    Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(Color.blue)
                }
                .buttonStyle(.plain)
            }
            .onChange(of: scenePhase) { _, newValue in
                if newValue == .inactive {
                    task.title = task.title
                }
            }
            if let taskImage = task.taskImage,
               let uiImage = UIImage(data: taskImage) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .contentShape(Rectangle().inset(by: 10))
                    .onTapGesture {
                        isImageFullScreen = true
                    }
                    .fullScreenCover(isPresented: $isImageFullScreen) {
                        SwiftUIImageViewer(image: Image(uiImage: uiImage))
                            .overlay(alignment: .topTrailing) {
                                Button {
                                    isImageFullScreen = false
                                } label: {
                                    Image(systemName: "xmark")
                                        .font(.headline)
                                }
                                .buttonStyle(.bordered)
                                .clipShape(Circle())
                                .tint(.red)
                                .padding()
                            }
                    }
            }
            if !task.location.isEmpty {
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                    Text((task.location))
                }
                .font(.subheadline)
                .foregroundStyle(.blue)
                .onTapGesture {
                    openLocationInMaps()
                }
            }
        }
    }
}

extension SingleTaskView {
    func openLocationInMaps() {
        let coordinate = CLLocationCoordinate2D(latitude: task.latitude!, longitude: task.longitude!)
        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = task.location
        mapItem.openInMaps()
    }
}

#Preview {
    SingleTaskView(task: TaskItem.preview)
}

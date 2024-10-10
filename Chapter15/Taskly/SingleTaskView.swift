//
//  SingleTaskView.swift
//  Taskly
//
//  Created by Nathan Sebhastian on 20/09/24.
//

import SwiftUI
import SwiftUIImageViewer

struct SingleTaskView: View {
    
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
                } label: {
                    Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(Color.blue)
                }
                .buttonStyle(.plain)
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
        }
    }
}

#Preview {
    SingleTaskView(task: TaskItem.preview)
}

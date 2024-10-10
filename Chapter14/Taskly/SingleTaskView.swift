//
//  SingleTaskView.swift
//  Taskly
//
//  Created by Nathan Sebhastian on 20/09/24.
//

import SwiftUI

struct SingleTaskView: View {
    
    let task: TaskItem
    
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
        }
    }
}

#Preview {
    let sampleTask: TaskItem = TaskItem(title: "Sample Task", notes: "Sample Notes", dueDate: Date(), isCompleted: false)
    SingleTaskView(task: sampleTask)
}

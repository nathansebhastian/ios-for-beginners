//
//  TaskListView.swift
//  Taskly
//
//  Created by Nathan Sebhastian on 20/09/24.
//

import SwiftUI
import SwiftData

struct TaskListView: View {
    
    @Query var tasks: [TaskItem]
    @State var showTaskForm = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(tasks) { task in
                    Text(task.title)
                }
            }
            .navigationTitle("Task List")
            .toolbar {
                ToolbarItem {
                    Button {
                        showTaskForm = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .navigationDestination(isPresented: $showTaskForm) {
                TaskFormView()
            }
        }
    }
}

#Preview {
    TaskListView()
}

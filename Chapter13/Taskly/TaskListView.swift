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
    @State var taskToEdit: TaskItem?
    
    @State var searchText = ""
    
    var searchResults: [TaskItem] {
        if searchText.isEmpty {
            return tasks
        } else {
            return tasks.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) || $0.notes.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(searchResults) { task in
                    SingleTaskView(task: task)
                        .swipeActions(edge: .leading) {
                            Button("Edit") {
                                showTaskForm = true
                                taskToEdit = task
                            }.tint(.green)
                        }
                }
            }
            .searchable(text: $searchText, prompt: "Look for a specific task")
            .navigationTitle("Task List")
            .toolbar {
                ToolbarItem {
                    Button {
                        showTaskForm = true
                        taskToEdit = nil
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .navigationDestination(isPresented: $showTaskForm) {
                TaskFormView(taskToEdit: $taskToEdit)
            }
        }
    }
}

#Preview {
    TaskListView()
}

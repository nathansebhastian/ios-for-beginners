//
//  TaskListView.swift
//  Taskly
//
//  Created by Nathan Sebhastian on 20/09/24.
//

import SwiftUI
import SwiftData
import WidgetKit

struct TaskListView: View {
    @Environment(\.modelContext) var modelContext
    
    @Query var tasks: [TaskItem]
    @State var showTaskForm = false
    @State var taskToEdit: TaskItem?
    
    @State var searchText = ""
            
    @State var showDeleteConfirmation = false
    @State var taskToDelete: TaskItem?
    
    @State var isAscending = false
    
    var searchResults: [TaskItem] {
        let filtered = tasks.filter { task in
            searchText.isEmpty ||
            task.title.localizedCaseInsensitiveContains(searchText) ||
            task.notes.localizedCaseInsensitiveContains(searchText)
        }
        return filtered.sorted { isAscending ? $0.dueDate < $1.dueDate : $0.dueDate > $1.dueDate }
    }
    
    func removeTask(taskToDelete: TaskItem) {
        withAnimation {
            modelContext.delete(taskToDelete)
        }
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    enum Filter {
        case none, completed, notCompleted
    }
        
    init(filter: Filter) {
        if filter != .none {
            let showCompletedOnly = filter == .completed
            
            _tasks = Query(filter: #Predicate {
                $0.isCompleted == showCompletedOnly
            })
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(searchResults) { task in
                    SingleTaskView(task: task)
                        .swipeActions(edge: .trailing) {
                            Button("Delete") {
                                taskToDelete = task
                                showDeleteConfirmation = true
                            }.tint(.red)
                        }
                        .swipeActions(edge: .leading) {
                            Button("Edit") {
                                showTaskForm = true
                                taskToEdit = task
                            }.tint(.green)
                        }
                        
                }
            }
            .alert(isPresented: $showDeleteConfirmation) {
                Alert(
                    title: Text("Are you sure you want to delete this task?"),
                    message: Text("This action cannot be undone"),
                    primaryButton: .destructive(Text("Delete")) {
                        if let task = taskToDelete {
                            removeTask(taskToDelete: task)
                        }
                    },
                    secondaryButton: .cancel() {
                        taskToDelete = nil
                    }
                )
            }
            .searchable(text: $searchText, prompt: "Look for a specific task")
            .navigationTitle("Task List")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        isAscending.toggle()
                    }) {
                        HStack {
                            Image(systemName: "calendar")
                            Image(systemName: isAscending ? "arrow.down" : "arrow.up")
                        }
                    }
                }
                ToolbarItem {
                    Button {
                        taskToEdit = nil
                        showTaskForm = true
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
    TaskListView(filter: .none)
}

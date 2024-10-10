//
//  TaskFormView.swift
//  Taskly
//
//  Created by Nathan Sebhastian on 20/09/24.
//

import SwiftUI

struct TaskFormView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State var title = ""
    @State var notes = ""
    @State var dueDate = Date()
    @State var isCompleted = false
    
    @State var showAlert = false
    
    @Binding var taskToEdit: TaskItem?
    
    var validate: Bool {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty
        else {
            return false
        }
        return true
    }
    
    func addTask() {
        let newTask = TaskItem(title: title, notes: notes, dueDate: dueDate, isCompleted: isCompleted)
        modelContext.insert(newTask)
    }
    
    func updateTask() {
        taskToEdit?.title = title
        taskToEdit?.notes = notes
        taskToEdit?.dueDate = dueDate
        taskToEdit?.isCompleted = isCompleted
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section {
                        TextField("Title", text: $title)
                            .textFieldStyle(DefaultTextFieldStyle())
                        TextField("Notes...", text: $notes, axis: .vertical)
                            .foregroundStyle(.secondary)
                            .lineLimit(5...10)
                        
                        DatePicker("Due Date", selection: $dueDate)
                            .datePickerStyle(CompactDatePickerStyle())
                    }
                    Section {
                        Toggle("Done", isOn: $isCompleted)
                    }
                }
            }
            .onAppear(perform: {
                if let taskToEdit {
                    title = taskToEdit.title
                    notes = taskToEdit.notes
                    dueDate = taskToEdit.dueDate
                    isCompleted = taskToEdit.isCompleted
                }
            })
            .alert(isPresented: $showAlert, content: {
                Alert(title: Text("Error"), message: Text("Please fill in the title field") )
            })
            .navigationTitle(taskToEdit != nil ? "Edit Task" : "Create Task")
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(taskToEdit != nil ? "Update Task" : "Save Task") {
                        if validate {
                            if taskToEdit != nil {
                                updateTask()
                            } else {
                                addTask()
                            }
                            dismiss()
                        }  else {
                            showAlert = true
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var sampleTask: TaskItem? = TaskItem(title: "Sample Task", notes: "Sample Notes", dueDate: Date(), isCompleted: false)
    
    TaskFormView(taskToEdit: $sampleTask)
}

//
//  TaskFormView.swift
//  Taskly
//
//  Created by Nathan Sebhastian on 20/09/24.
//

import SwiftUI
import PhotosUI

struct TaskFormView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State var title = ""
    @State var notes = ""
    @State var dueDate = Date()
    @State var isCompleted = false
    
    @State var selectedImage: PhotosPickerItem?
    @State var taskImage: Data?
    
    @State var taskLocation: String = ""
    @State var taskLat: Double? = nil
    @State var taskLong: Double? = nil
    
    @State var openMap = false
    
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
        let newTask = TaskItem(title: title, notes: notes, dueDate: dueDate, isCompleted: isCompleted, taskImage: taskImage, location: taskLocation, latitude: taskLat, longitude: taskLong)
        modelContext.insert(newTask)
    }
    
    func updateTask() {
        taskToEdit?.title = title
        taskToEdit?.notes = notes
        taskToEdit?.dueDate = dueDate
        taskToEdit?.isCompleted = isCompleted
        taskToEdit?.taskImage = taskImage
        taskToEdit?.location = taskLocation
        taskToEdit?.latitude = taskLat
        taskToEdit?.longitude = taskLong
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
                    Section {
                        if let taskImage,
                           let img = UIImage(data: taskImage){
                            Image(uiImage: img)
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity, maxHeight: 300)
                        }
                        if taskImage != nil {
                            Button(role: .destructive) {
                                withAnimation {
                                    selectedImage = nil
                                    taskImage = nil
                                }
                            } label: {
                                Label("Remove Image", systemImage: "xmark.circle").foregroundStyle(.red)
                            }
                        }
                        PhotosPicker(selection: $selectedImage, matching: .images) {
                            Label("Add Image", systemImage: "photo")
                        }
                    }
                    Section("Add Location") {
                        HStack {
                            Text(taskLocation.isEmpty ? "Add a location..." : taskLocation)
                                .foregroundStyle(.gray)
                                .opacity(0.5)
                            Spacer()
                            Button {
                                openMap.toggle()
                            } label: {
                                Image(systemName: "mappin.square.fill")
                                    .font(.title)
                            }
                        }
                    }
                }
            }
            .sheet(isPresented: $openMap) {
                MapView(loc: $taskLocation, lat: $taskLat, long: $taskLong)
            }
            .task(id:selectedImage) {
                if let data = try? await selectedImage?.loadTransferable(type: Data.self){
                    taskImage = data
                }
            }
            .onAppear(perform: {
                if let taskToEdit {
                    title = taskToEdit.title
                    notes = taskToEdit.notes
                    dueDate = taskToEdit.dueDate
                    isCompleted = taskToEdit.isCompleted
                    taskImage = taskToEdit.taskImage
                    taskLocation = taskToEdit.location
                    taskLat = taskToEdit.latitude
                    taskLong = taskToEdit.longitude
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
    @Previewable @State var sampleTask: TaskItem? = TaskItem.preview
    TaskFormView(taskToEdit: $sampleTask)
}

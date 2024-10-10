//
//  TaskItem.swift
//  Taskly
//
//  Created by Nathan Sebhastian on 20/09/24.
//

import Foundation
import SwiftData

@Model
class TaskItem {
    private(set) var taskID: String = UUID().uuidString
    var title: String
    var notes: String
    var dueDate: Date
    var isCompleted: Bool
    
    // save image data in external storage
    @Attribute(.externalStorage)
    var taskImage: Data?
    
    init(title: String, notes: String, dueDate: Date, isCompleted: Bool, taskImage: Data?) {
        self.title = title
        self.notes = notes
        self.dueDate = dueDate
        self.isCompleted = isCompleted
        self.taskImage = taskImage
    }
}

extension TaskItem {
    static var preview: TaskItem {
        TaskItem(
            title: "Sample Task",
            notes: "Sample Notes",
            dueDate: Date(),
            isCompleted: false,
            taskImage: nil
        )
    }
}

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
    
    init(title: String, notes: String, dueDate: Date, isCompleted: Bool) {
        self.title = title
        self.notes = notes
        self.dueDate = dueDate
        self.isCompleted = isCompleted
    }
}

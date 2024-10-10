//
//  TasklyApp.swift
//  Taskly
//
//  Created by Nathan Sebhastian on 20/09/24.
//

import SwiftUI
import SwiftData

@main
struct TasklyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: TaskItem.self)
    }
}

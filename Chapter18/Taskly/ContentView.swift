//
//  ContentView.swift
//  Taskly
//
//  Created by Nathan Sebhastian on 20/09/24.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        TabView {
            Tab("All Tasks", systemImage: "list.bullet") {
                TaskListView(filter: .none)
            }
            Tab("Completed", systemImage: "checkmark.circle") {
                TaskListView(filter: .completed)
            }
            Tab("Not Completed", systemImage: "ellipsis.circle") {
                TaskListView(filter: .notCompleted)
            }
        }
    }
}

#Preview {
    ContentView()
}
